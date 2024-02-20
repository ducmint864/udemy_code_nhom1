// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract WillThrow {
    function aFunction() public pure {
        require(false, "This is just a test error message");
    }
}

// Custom error
contract WillThrow2 {
    error ThisIsACustomError(string, string);
    function aFunction() public pure {
        revert ThisIsACustomError("This is just a ", "custom error");
    }
}

contract ErrorHandling {
    event ErrorLogging(string reason);
    event ErrorLogging2(bytes data);
    event SuccessLogging(string message);

    function catchErrorAndEmit1() public {
        WillThrow w = new WillThrow();
        try w.aFunction() {
            emit SuccessLogging("No error occurred");
        } catch Error(string memory reason) {
            emit ErrorLogging(reason);
        }
    }
    
    function catchErrorAndEmit2() public {
        WillThrow2 w2 = new WillThrow2();
        try w2.aFunction() {
            emit SuccessLogging("No error occurred");
        } catch (bytes memory lowLevelData) {
            emit ErrorLogging2(lowLevelData);
        }
    }
}
