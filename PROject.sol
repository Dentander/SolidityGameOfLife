// SPDX-License-Identifier: MIT
 
pragma solidity 0.8.17;

 
contract GameOfLife {
    bytes1 deadCell = bytes(".")[0];
    bytes1 aliveCell = bytes("#")[0];
    bytes char = new bytes(1);
    bytes emptyLine;

    uint256 width = 20;
    uint256 height = 10;

    // Тут глайдер, он двигается вправо вниз
    string[] fieldToConvert = [
        "......................",
        "...#..................",
        ".#.#..................",
        "..##..................",
        "......................",
        "......................",
        "......................",
        "......................",
        "......................",
        "......................",
        "......................",
        "......................"
    ]; 

    bytes[] field;
    bytes[] nextField;

    constructor() {
        initField();
    }

    function initEmptyLine() private {
        string memory line = "";
        for (uint256 i = 0; i < width + 2; ++i)
            line = string.concat(line, ".");

        emptyLine = bytes(line);
    }

    function initField() private {
        initEmptyLine();
        for (uint256 i = 0; i < height + 2; ++i) {
            field.push(bytes(fieldToConvert[i]));
            nextField.push(emptyLine);
        }
    }

    function getField() public view returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        return (
            string(field[1]), 
            string(field[2]), 
            string(field[3]), 
            string(field[4]), 
            string(field[5]), 
            string(field[6]), 
            string(field[7]), 
            string(field[8]), 
            string(field[9]), 
            string(field[10])
        );
    }

    function prepareNextField() private {
        for (uint256 i = 0; i < height + 2; ++i) {
            nextField[i] = emptyLine;
        }
    }

    function countNeighbours(int256 x0, int256 y0) private view returns (uint256) {
        uint256 count = 0;
        for (int256 x = -1; x <= 1; ++x) {
            for (int256 y = -1; y <= 1; ++y) {
                if (!(x == 0 && y == 0)) {
                    uint256 ax = uint256(x0 + x);
                    uint256 ay = uint256(y0 + y);
                    if (field[ay][ax] == aliveCell) {
                        ++count;
                    }
                }
            }
        }
        return count;
    }

    function update() public returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        prepareNextField();
        for (uint256 y = 1; y <= height; ++y) {
            for (uint256 x = 1; x <= width; ++x) {
                uint256 count = countNeighbours(int256(x), int256(y));
                
                if ((field[y][x] == aliveCell && (count == 2 || count == 3)) ||
                    (field[y][x] == deadCell  &&  count == 3)) {

                    nextField[y][x] = aliveCell;
                }
            }
        }
        field = nextField;
        return getField();
    }

    function setDead(uint256 x, uint256 y) public returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        require(x > 0, "Outside the bounds of array");
        require(y > 0, "Outside the bounds of array");
        require(x <= width, "Outside the bounds of array");
        require(y <= height, "Outside the bounds of array");

        field[x][y] = deadCell;
        return getField();
    }

    function setAlive(uint256 x, uint256 y) public returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        require(x > 0, "Outside the bounds of array");
        require(y > 0, "Outside the bounds of array");
        require(x <= width, "Outside the bounds of array");
        require(y <= height, "Outside the bounds of array");

        field[x][y] = aliveCell;
        return getField();
    }

    function clearField() public returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        prepareNextField();
        field = nextField;
        return getField();
    }
}
