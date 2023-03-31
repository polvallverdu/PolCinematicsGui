import 'package:uuid/uuid.dart';

enum EAttributeType { Boolean, Double, Integer, String, Color, CameraPos }

class CameraPos {
  double x;
  double y;
  double z;
  double pitch;
  double yaw;
  double roll;
  double fov;

  CameraPos(this.x, this.y, this.z, this.pitch, this.yaw, this.roll, this.fov);
}

enum EEasing {
  EASE_IN_SINE,
  EASE_OUT_SINE,
  EASE_INOUT_SINE,
  EASE_IN_QUAD,
  EASE_OUT_QUAD,
  EASE_INOUT_QUAD,
  EASE_IN_CUBIC,
  EASE_OUT_CUBIC,
  EASE_INOUT_CUBIC,
  EASE_IN_QUART,
  EASE_OUT_QUART,
  EASE_INOUT_QUART,
  EASE_IN_QUINT,
  EASE_OUT_QUINT,
  EASE_INOUT_QUINT,
  EASE_IN_EXPO,
  EASE_OUT_EXPO,
  EASE_INOUT_EXPO,
  EASE_IN_CIRC,
  EASE_OUT_CIRC,
  EASE_INOUT_CIRC,
  LINEAR,
  INSTANT,
  CUSTOM, // TODO: Implement custom easing
}

class Keyframe {
  int time;
  EEasing easing;
  EAttributeType type;
  dynamic value;

  Keyframe(this.time, this.easing, this.type, this.value);
}

class Attribute {
  String UUID;
  String name;
  String description;
  EAttributeType type;
  List<Keyframe> keyframes;

  Attribute(this.UUID, this.name, this.description, this.type, this.keyframes);
}

enum ECameraType {
  Player,
  Fixed,
  // LerpCamera,
  // SlerpCamera,
}

enum EOverlayType {
  Solid,
  BlackBars,
  Video,
}

enum ECompositionType {
  CAMERA,
  OVERLAY,
  AUDIO, // Currently not implemented
}

class CameraComposition extends Composition {
  ECameraType cameraType;

  CameraComposition(String UUID, String name, int duration, this.cameraType,
      List<Attribute> attributes)
      : super(UUID, name, duration, ECompositionType.CAMERA, attributes);
}

class Composition {
  String UUID;
  String name;
  int duration;
  ECompositionType type;
  List<Attribute> attributes;

  Composition(this.UUID, this.name, this.duration, this.type, this.attributes);
}

class WrappedComposition {
  Composition composition;
  int startTime;

  WrappedComposition(this.composition, this.startTime);

  int get endTime => startTime + composition.duration;
}

enum EOverlapMethod {
  MOVE,
  ERROR,
}

class Timeline {
  EOverlapMethod overlapMethod;
  List<WrappedComposition> compositions;

  Timeline(this.overlapMethod, this.compositions);
}

class Cinematic {
  String UUID;
  String name;
  int duration;
  Timeline cameraTimeline;
  List<Timeline> timelines;

  Cinematic(
      this.UUID, this.name, this.duration, this.cameraTimeline, this.timelines);
}

class DummyCinematic extends Cinematic {
  DummyCinematic()
      : super(
            Uuid().toString(),
            "Dummy Cinematic",
            15000,
            Timeline(EOverlapMethod.MOVE, []),
            [Timeline(EOverlapMethod.ERROR, [])]);
}

class SimpleCinematic {
  String UUID;
  String name;

  SimpleCinematic(this.UUID, this.name);

  factory SimpleCinematic.fromJson(Map<String, dynamic> json) {
    return SimpleCinematic(json['UUID'], json['name']);
  }
}
