extends Node

const TILE_SIZE = 140

var first_block : RigidBody2D

signal HANDLE_LEVEL_WON
signal HANDLE_TILE_CLICKED(tile)

func create_2d_vector(vec : Vector2):
	var array = []
	for i in vec.x:
		array.append([])
		for j in vec.y:
			array[i].append(null)
	return array

func GetNeighbours(matrix, i, j):
	var result = []
	if i > 0 and matrix[i-1][j] != null:
		result.append(matrix[i-1][j])
	if j > 0 and matrix[i][j-1] != null:
		result.append(matrix[i][j-1])
	if i + 1 < matrix.size() and matrix[i+1][j] != null:
		result.append(matrix[i+1][j])
	if j + 1 < matrix[i].size() and matrix[i][j+1] != null:
		result.append(matrix[i][j+1])
	return result
