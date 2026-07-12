class_name DialogueLineResource extends Resource

## the status of the speaker, can get passed to the speaker
@export var status: String = "neutral"

@export var speaker: String = "npc"
@export var voice: VoiceResource

## background color of the dialogue box
@export var color: Color = Color("#0112fd")

@export_multiline var text: String
