
// lib/class/pet_checklist.dart
class ChecklistItem {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  
  ChecklistItem({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }
  
  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class PetChecklist {
  final String id;
  final String tripId;
  final List<ChecklistItem> pickupItems;
  final List<ChecklistItem> inProgressItems;
  final List<ChecklistItem> dropoffItems;
  
  PetChecklist({
    required this.id,
    required this.tripId,
    required this.pickupItems,
    required this.inProgressItems,
    required this.dropoffItems,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'pickupItems': pickupItems.map((item) => item.toJson()).toList(),
      'inProgressItems': inProgressItems.map((item) => item.toJson()).toList(),
      'dropoffItems': dropoffItems.map((item) => item.toJson()).toList(),
    };
  }
  
  factory PetChecklist.fromJson(Map<String, dynamic> json) {
    return PetChecklist(
      id: json['id'],
      tripId: json['tripId'],
      pickupItems: (json['pickupItems'] as List)
          .map((item) => ChecklistItem.fromJson(item))
          .toList(),
      inProgressItems: (json['inProgressItems'] as List)
          .map((item) => ChecklistItem.fromJson(item))
          .toList(),
      dropoffItems: (json['dropoffItems'] as List)
          .map((item) => ChecklistItem.fromJson(item))
          .toList(),
    );
  }
}