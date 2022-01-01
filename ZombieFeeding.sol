pragma solidity >=0.8.10;
import "./ZombieFactory.sol";

//CryptoKitties are  in public blockchain. 
//Cryptozombies feed on kitties. Sad. I know
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory{
    
    
  
    KittyInterface kittyContract;
    
    function feedAndMultiply (uint _zombieId, uint _targetDna, string memory _species) public
    {
    require(msg.sender == zombieToOwner[_zombieId]); 
    Zombie storage myZombie = zombies[_zombieId];  

    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);
    
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

  function setKittyContractAddress (uint _address) external{
    kittyContract = KittyInterface(_address);
  }
}