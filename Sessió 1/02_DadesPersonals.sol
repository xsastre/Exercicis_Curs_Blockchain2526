// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DadesPersonals {
    
    // Variables d'estat
    string public nom;
    uint256 public edat;
    address public propietari;
    bool public verificat;
    
    // Constructor amb paràmetres
    constructor(string memory _nom, uint256 _edat) {
        nom = _nom;
        edat = _edat;
        propietari = msg.sender;
        verificat = false;
    }
    
    // Funció per verificar les dades
    function verificar() public {
        verificat = true;
    }
    
    // Funció per actualitzar l'edat
    function actualitzarEdat(uint256 novaEdat) public {
        require(novaEdat > 0, "L'edat ha de ser major que 0");
        require(novaEdat < 150, "L'edat no pot ser tan alta");
        edat = novaEdat;
    }
    
    // Funció per obtenir totes les dades
    function obtenirDadesCompletes() public view returns (
        string memory,
        uint256,
        address,
        bool
    ) {
        return (nom, edat, propietari, verificat);
    }
    
    // Funció pure per calcular anys fins als 100
    function anysFins100() public view returns (uint256) {
        if (edat >= 100) {
            return 0;
        }
        return 100 - edat;
    }
}