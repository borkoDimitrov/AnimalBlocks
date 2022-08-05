extends Node

const TILE_SIZE = 140

var first_block : RigidBody2D

signal HANDLE_TILE_CLICKED(tile)
signal HANDLE_MATCH_TILES(matches_count)
signal HANDLE_SKILL_ACTIVATION(current_skill)
signal HANDLE_SKILL_DEACTIVATION(current_skill)

