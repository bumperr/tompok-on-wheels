from fastapi import FastAPI, HTTPException, Depends, status
from pydantic import BaseModel, EmailStr, Field, constr
from typing import List, Optional, Dict, Any
from datetime import datetime, date
import sqlalchemy
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, Column, Integer, String, DateTime, Boolean, Numeric, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from passlib.hash import pbkdf2_sha256
import jwt
from uuid import uuid4

# Database Configuration
DATABASE_URL = "postgresql://user:password@localhost/tompok_on_wheels"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Pydantic Models for Request/Response Validation
class UserBase(BaseModel):
    email: EmailStr
    first_name: str
    last_name: str
    phone: constr(regex=r'^\+?[0-9]{10,14}$')

class UserCreate(UserBase):
    password: str

class UserResponse(UserBase):
    user_id: int
    role: str
    
class PetBase(BaseModel):
    name: str
    breed: Optional[str] = None
    age: int = Field(gt=0, le=20)
    weight: Optional[float] = Field(None, gt=0, le=25)
    medical_notes: Optional[str] = None
    special_requirements: Optional[str] = None

class PetCreate(PetBase):
    user_id: int
    type_id: int

class PetResponse(PetBase):
    pet_id: int
    vaccination_status: bool
    last_vet_visit: Optional[date] = None

class ServiceProviderBase(BaseModel):
    name: str
    address: str
    phone: constr(regex=r'^\+?[0-9]{10,14}$')
    email: EmailStr

class ServiceProviderCreate(ServiceProviderBase):
    category_id: int
    user_id: int

class ServiceProviderResponse(ServiceProviderBase):
    provider_id: int
    category_name: str
    verification_status: bool

class ServiceBase(BaseModel):
    name: str
    description: Optional[str] = None
    price: float = Field(gt=0)
    duration_minutes: int = Field(gt=0)

class ServiceCreate(ServiceBase):
    provider_id: int

class ServiceResponse(ServiceBase):
    service_id: int
    provider_name: str

# API Functions Class
class TompokCatAPI:
    def __init__(self, db: Session):
        self.db = db

    def create_user(self, user: UserCreate) -> Dict[str, Any]:
        """
        Create a new user with hashed password
        """
        try:
            # Check if email already exists
            existing_user = self.db.query(User).filter(User.email == user.email).first()
            if existing_user:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST, 
                    detail="Email already registered"
                )

            # Determine default role (pet owner)
            default_role = self.db.query(UserRole).filter(UserRole.name == 'pet_owner').first()
            if not default_role:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
                    detail="Default role not found"
                )

            # Hash password
            hashed_password = pbkdf2_sha256.hash(user.password)

            # Create new user
            new_user = User(
                role_id=default_role.role_id,
                email=user.email,
                password_hash=hashed_password,
                salt=str(uuid4()),  # Generate unique salt
                first_name=user.first_name,
                last_name=user.last_name,
                phone=user.phone,
                status='active'
            )

            self.db.add(new_user)
            self.db.commit()
            self.db.refresh(new_user)

            return {
                "user_id": new_user.user_id,
                "email": new_user.email,
                "first_name": new_user.first_name,
                "last_name": new_user.last_name,
                "role": default_role.name
            }
        except Exception as e:
            self.db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
                detail=f"User creation failed: {str(e)}"
            )

    def create_pet(self, pet: PetCreate) -> PetResponse:
        """
        Create a new pet for a user
        """
        try:
            # Verify user exists
            user = self.db.query(User).filter(User.user_id == pet.user_id).first()
            if not user:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND, 
                    detail="User not found"
                )

            # Verify pet type exists
            pet_type = self.db.query(PetType).filter(PetType.type_id == pet.type_id).first()
            if not pet_type:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND, 
                    detail="Pet type not found"
                )

            # Create new pet
            new_pet = Pet(
                user_id=pet.user_id,
                type_id=pet.type_id,
                name=pet.name,
                breed=pet.breed,
                age=pet.age,
                weight=pet.weight,
                medical_notes=pet.medical_notes,
                special_requirements=pet.special_requirements,
                vaccination_status=True,  # Default to vaccinated
                last_vet_visit=date.today()
            )

            self.db.add(new_pet)
            self.db.commit()
            self.db.refresh(new_pet)

            return PetResponse(
                pet_id=new_pet.pet_id,
                name=new_pet.name,
                breed=new_pet.breed,
                age=new_pet.age,
                weight=new_pet.weight,
                medical_notes=new_pet.medical_notes,
                special_requirements=new_pet.special_requirements,
                vaccination_status=new_pet.vaccination_status,
                last_vet_visit=new_pet.last_vet_visit
            )
        except Exception as e:
            self.db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
                detail=f"Pet creation failed: {str(e)}"
            )

    def create_service_provider(self, provider: ServiceProviderCreate) -> ServiceProviderResponse:
        """
        Create a new service provider
        """
        try:
            # Verify user exists
            user = self.db.query(User).filter(User.user_id == provider.user_id).first()
            if not user:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND, 
                    detail="User not found"
                )

            # Verify category exists
            category = self.db.query(ServiceProviderCategory).filter(
                ServiceProviderCategory.category_id == provider.category_id
            ).first()
            if not category:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND, 
                    detail="Service provider category not found"
                )

            # Create new service provider
            new_provider = ServiceProvider(
                user_id=provider.user_id,
                category_id=provider.category_id,
                name=provider.name,
                address=provider.address,
                phone=provider.phone,
                email=provider.email,
                verification_status=False  # Default to unverified
            )

            self.db.add(new_provider)
            self.db.commit()
            self.db.refresh(new_provider)

            return ServiceProviderResponse(
                provider_id=new_provider.provider_id,
                name=new_provider.name,
                address=new_provider.address,
                phone=new_provider.phone,
                email=new_provider.email,
                category_name=category.name,
                verification_status=new_provider.verification_status
            )
        except Exception as e:
            self.db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
                detail=f"Service provider creation failed: {str(e)}"
            )

    def create_service(self, service: ServiceCreate) -> ServiceResponse:
        """
        Create a new service for a service provider
        """
        try:
            # Verify service provider exists
            provider = self.db.query(ServiceProvider).filter(
                ServiceProvider.provider_id == service.provider_id
            ).first()
            if not provider:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND, 
                    detail="Service provider not found"
                )

            # Create new service
            new_service = Service(
                provider_id=service.provider_id,
                name=service.name,
                description=service.description,
                price=service.price,
                duration_minutes=service.duration_minutes,
                max_capacity=1  # Default to 1
            )

            self.db.add(new_service)
            self.db.commit()
            self.db.refresh(new_service)

            return ServiceResponse(
                service_id=new_service.service_id,
                name=new_service.name,
                description=new_service.description,
                price=new_service.price,
                duration_minutes=new_service.duration_minutes,
                provider_name=provider.name
            )
        except Exception as e:
            self.db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
                detail=f"Service creation failed: {str(e)}"
            )

    def get_cats_by_user(self, user_id: int) -> List[PetResponse]:
        """
        Retrieve all cats for a specific user
        """
        try:
            # Verify user exists
            user = self.db.query(User).filter(User.user_id == user_id).first()
            if not user:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND, 
                    detail="User not found"
                )

            # Get cat type
            cat_type = self.db.query(PetType).filter(PetType.name == 'Cat').first()
            if not cat_type:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
                    detail="Cat type not found in system"
                )

            # Retrieve cats
            cats = self.db.query(Pet).filter(
                Pet.user_id == user_id, 
                Pet.type_id == cat_type.type_id
            ).all()

            return [
                PetResponse(
                    pet_id=cat.pet_id,
                    name=cat.name,
                    breed=cat.breed,
                    age=cat.age,
                    weight=cat.weight,
                    medical_notes=cat.medical_notes,
                    special_requirements=cat.special_requirements,
                    vaccination_status=cat.vaccination_status,
                    last_vet_visit=cat.last_vet_visit
                ) for cat in cats
            ]
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
                detail=f"Failed to retrieve cats: {str(e)}"
            )

    def get_cat_services(self, city: Optional[str] = None) -> List[ServiceResponse]:
        """
        Retrieve cat-related services, optionally filtered by city
        """
        try:
            # Start with cat-related service providers
            query = self.db.query(Service).join(ServiceProvider)
            
            # If city is provided, filter by city
            if city:
                query = query.filter(ServiceProvider.address.ilike(f'%{city}%'))
            
            # Get services
            services = query.all()

            return [
                ServiceResponse(
                    service_id=service.service_id,
                    name=service.name,
                    description=service.description,
                    price=service.price,
                    duration_minutes=service.duration_minutes,
                    provider_name=service.provider.name
                ) for service in services
            ]
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
                detail=f"Failed to retrieve services: {str(e)}"
            )

# SQLAlchemy ORM Models (Simplified for context)
class UserRole(Base):
    __tablename__ = 'user_roles'
    role_id = Column(Integer, primary_key=True)
    name = Column(String, unique=True)

class User(Base):
    __tablename__ = 'users'
    user_id = Column(Integer, primary_key=True)
    role_id = Column(Integer, ForeignKey('user_roles.role_id'))
    email = Column(String, unique=True)
    password_hash = Column(String)
    salt = Column(String)
    first_name = Column(String)
    last_name = Column(String)
    phone = Column(String)
    status = Column(String)

class PetType(Base):
    __tablename__ = 'pet_types'
    type_id = Column(Integer, primary_key=True)
    name = Column(String)

class Pet(Base):
    __tablename__ = 'pets'
    pet_id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.user_id'))
    type_id = Column(Integer, ForeignKey('pet_types.type_id'))
    name = Column(String)
    breed = Column(String)
    age = Column(Integer)
    weight = Column(Numeric)
    medical_notes = Column(String)
    special_requirements = Column(String)
    vaccination_status = Column(Boolean)
    last_vet_visit = Column(DateTime)

class ServiceProviderCategory(Base):
    __tablename__ = 'service_provider_categories'
    category_id = Column(Integer, primary_key=True)
    name = Column(String, unique=True)

class ServiceProvider(Base):
    __tablename__ = 'service_providers'
    provider_id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.user_id'))
    category_id = Column(Integer, ForeignKey('service_provider_categories.category_id'))
    name = Column(String)
    address = Column(String)
    phone = Column(String)
    email = Column(String)
    verification_status = Column(Boolean)

class Service(Base):
    __tablename__ = 'services'
    service_id = Column(Integer, primary_key=True)
    provider_id = Column(Integer, ForeignKey('service_providers.provider_id'))
    name = Column(String)
    description = Column(String)
    price = Column(Numeric)
    duration_minutes = Column(Integer)
    max_capacity = Column(Integer)
    # Relationship for easier access to provider details
    provider = relationship("ServiceProvider")

# FastAPI App Setup
app = FastAPI