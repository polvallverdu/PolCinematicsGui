enum EKeyframeType {
  Boolean,
  Double,
  Integer,
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
  int timestamp;
  EEasing easing;
  dynamic value;

  Keyframe(this.timestamp, this.easing, this.value);
}

class Attribute {
  EKeyframeType type;
  dynamic? min, max;
  List<Keyframe> keyframes;

  Attribute(this.type, this.min, this.max, this.keyframes);
}

enum ECameraType { Player, FirstPerson, ThirdPerson, Fixed }

enum ECompositionType { Video, Audio, Image, Text, Camera }

class CameraComposition extends Composition {
  ECameraType cameraType;

  CameraComposition(this.cameraType, List<Attribute> attributes)
      : super(ECompositionType.Camera, attributes);
}

class Composition {
  ECompositionType type;
  List<Attribute> attributes;

  Composition(this.type, this.attributes);
}

enum EOverlapMethod {
  MOVE,
  ERROR,
}

class Timeline {
  EOverlapMethod overlapMethod;
  List<Composition> compositions;

  Timeline(this.overlapMethod, this.compositions);
}

class Cinematic {
  Timeline cameraTimeline;
  List<Timeline> timelines;

  Cinematic(this.cameraTimeline, this.timelines);
}
