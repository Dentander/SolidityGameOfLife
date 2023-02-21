// SPDX-License-Identifier: MIT
 
pragma solidity 0.8.17;

 
contract GameOfLife {
    bytes1 deadCell = bytes(".")[0];
    bytes1 aliveCell = bytes("#")[0];
    bytes char = new bytes(1);
    bytes emptyLine;

    uint16 width = 20;
    uint16 height = 10;

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
        for (uint16 i = 0; i < width + 5; ++i)
            line = string.concat(line, ".");

        emptyLine = bytes(line);
    }

    function initField() private {
        initEmptyLine();
        for (uint16 i = 0; i < height + 2; ++i) {
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
        for (uint16 i = 0; i < height + 2; ++i) {
            nextField[i] = emptyLine;
        }
    }

    function countNeighbours(int16 x0, int16 y0) private view returns (uint16) {
        uint16 count = 0;
        for (int16 x = -1; x <= 1; ++x) {
            for (int16 y = -1; y <= 1; ++y) {
                if (!(x == 0 && y == 0)) {
                    uint16 ax = uint16(x0 + x);
                    uint16 ay = uint16(y0 + y);
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
        for (uint16 y = 1; y <= height; ++y) {
            for (uint16 x = 1; x <= width; ++x) {
                uint16 count = countNeighbours(int16(x), int16(y));

                if (field[y][x] == aliveCell && (count == 2 || count == 3) ||
                    field[y][x] == deadCell && count == 3) {

                    nextField[y][x] = aliveCell;
                }
            }
        }
        field = nextField;
        return getField();
    }

    function setDead(uint16 x, uint16 y) public returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        require(x > 0, "Outside the bounds of array");
        require(y > 0, "Outside the bounds of array");
        require(x <= width, "Outside the bounds of array");
        require(y <= height, "Outside the bounds of array");

        field[x][y] = deadCell;
        return getField();
    }

    function setAlive(uint16 x, uint16 y) public returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        require(x > 0, "Outside the bounds of array");
        require(y > 0, "Outside the bounds of array");
        require(x <= width, "Outside the bounds of array");
        require(y <= height, "Outside the bounds of array");

        field[x][y] = aliveCell;
        return getField();
    }
}
