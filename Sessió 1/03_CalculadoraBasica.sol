// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CalculadoraBasica {
    
    uint256 public ultimResultat;
    uint256 public historialOperacions;
    
    function sumar(uint256 a, uint256 b) public returns (uint256) {
        ultimResultat = a + b;
        historialOperacions++;
        return ultimResultat;
    }
    
    function restar(uint256 a, uint256 b) public returns (uint256) {
        require(a >= b, "No es permeten resultats negatius");
        ultimResultat = a - b;
        historialOperacions++;
        return ultimResultat;
    }
    
    function multiplicar(uint256 a, uint256 b) public returns (uint256) {
        ultimResultat = a * b;
        historialOperacions++;
        return ultimResultat;
    }
    
    function obtenirUltimResultat() public view returns (uint256) {
        return ultimResultat;
    }
    
    function obtenirHistorial() public view returns (uint256) {
        return historialOperacions;
    }
    
    function resetear() public {
        ultimResultat = 0;
        historialOperacions = 0;
    }
}