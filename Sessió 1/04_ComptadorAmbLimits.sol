// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ComptadorAmbLimits {
    uint256 private comptador;
    uint256 public constant LIMIT_MAXIM = 100;
    uint256 public constant LIMIT_MINIM = 0;

    constructor() {
        comptador = LIMIT_MINIM;
    }

    function incrementar() public {
        require(comptador < LIMIT_MAXIM, unicode"No es pot incrementar: límit màxim assolit");
        comptador += 1;
    }

    function decrementar() public {
        require(comptador > LIMIT_MINIM, unicode"No es pot decrementar: límit mínim assolit");
        comptador -= 1;
    }

    function obtenirComptador() public view returns (uint256) {
        return comptador;
    }

    function obtenirPercentatge() public view returns (uint256) {
        return (comptador * 100) / LIMIT_MAXIM;
    }
}