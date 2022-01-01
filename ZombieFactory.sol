pragma solidity >=0.8.10;

//https://cryptozombies.io/en/course
contract ZombieFactory
{
    //This is a state variable and will be a permanent one in blockchain.
    uint dnaDigits =  16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie{
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address)public zombieToOwner;
    mapping(address => uint) ownerZombieCount;
    
    event NewZombie(uint zombieId, string name, uint dna);

    function _createZombie (string memory _name, uint _dna) private 
    {   
        //Pass the parameters in order of declaration(first name, then dna)
        zombies.push(Zombie(_name, _dna));
        uint id = zombies.length -1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna (string memory _str) private view returns  (uint)
    {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;  
    }

    function createRandomZombie(string memory _name) public 
    {   
        //This statement requires that the one owner can have only one zombie
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}

