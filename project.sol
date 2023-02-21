// SPDX-License-Identifier: MIT
 
pragma solidity 0.8.17;

 
contract GameOfLife {
    uint256 width = 10;
    uint256 height = 10;

    string[] field = [
        "..........",
        "....#.....",
        "..#.#.....",
        "...##.....",
        "..........",
        "..........",
        "..........",
        "..........",
        "..........",
        "..........",
        "..........",
        ".........."
    ]; 
    string[] nextField;

    constructor() {
        string memory line = "";
        for (uint256 i = 0; i < width + 5; ++i) {
            line = string.concat(line, ".");
        }

        for (uint256 i = 0; i < height + 2; ++i) {
            nextField.push(line);
        }
    }

    function getField() public view returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        return (field[1], field[2], field[3], field[4], field[5], field[6], field[7], field[8], field[9], field[10]);
    }

    function prepareNextField() public {
        string memory line = "";
        for (uint256 i = 0; i < width + 2; ++i) {
            line = string.concat(line, ".");
        }

        for (uint256 i = 0; i < height + 2; ++i) {
            nextField[i] = line;
        }
    }

    function char(string memory text, uint256 pos) public view returns (string memory) {
        bytes memory tmp = new bytes(1);
        tmp[0] = bytes(text)[pos];
        return string(tmp);
    }

    function countNeighbours(int256 x0, int256 y0) public view returns (uint256) {
        uint256 res = 0;
        for (int256 y = -1; y <= 1; ++y) {
            for (int256 x = -1; x <= 1; ++x) {
                if (!(x == 0 && y == 0)) {

                    uint256 p = uint256(x0 + x);
                    string memory s = char(field[uint256(y0 + y)], p); 

                    if (keccak256(bytes(s)) == keccak256(bytes("#"))) {
                        ++res;
                    }
                }
            }
        }
        return res;
    }

    function update() public returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        prepareNextField();
        for (uint256 y = 1; y <= height; ++y) {
            for (uint256 x = 1; x <= width; ++x) {
                uint256 n = countNeighbours(int256(x), int256(y));
                /*if (n == 2 || n == 3) {
                    bytes memory tmp = bytes(nextField[y]);
                    tmp[x] = bytes("#")[0];
                    nextField[y] = string(tmp);
                }*/
            }
        }
        field = nextField;
        return getField();
    }
}

