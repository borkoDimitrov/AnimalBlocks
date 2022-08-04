extends Node

enum SKILL_EFECTS {NONE, SMALL_BOMB, SWITCH}
var state = SKILL_EFECTS.SWITCH

const TILE_SIZE = 140

var first_block : RigidBody2D

signal HANDLE_MATCH_TILES(matches_count)
