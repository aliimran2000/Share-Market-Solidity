pragma solidity 0.8.7;

/// @title Governable Contract
/// @author github.com/aliimran2000
/// @notice gives any contract a list of governers
contract CompaniesContract {
    string[] CompanyNamesList;
    address[] CompanyFounderList;

    constructor() {}

    struct CompanyDetail {
        string Name;
        uint256 totalStocks;
        uint256 stockPrice;
        bool isRegistered;
        bool isApproved;
    }

    

    mapping(address => CompanyDetail) public CompaniesDetails;

    function getCompanyDetails(address _Cpnyaddr)
        public
        view
        returns (CompanyDetail memory)
    {
        return CompaniesDetails[_Cpnyaddr];
    }

    function getAllCompanies() public view returns (address[] memory) {
        return CompanyFounderList;
    }

    function isApproved(address _CpnyAddr) public view returns (bool) {
        if (CompaniesDetails[_CpnyAddr].isApproved == true) {
            return true;
        } else {
            return false;
        }
    }

    function isRegistered(address _CpnyAddr) public view returns (bool) {
        if (CompaniesDetails[_CpnyAddr].isRegistered == true) {
            return true;
        } else {
            return false;
        }
    }

    function _requestRegisterMyCompany(
        address _msgSender,
        string memory _Name,
        uint256 _totalStocks,
        uint256 _stockPrice
    ) public payable {
        require(
            CompaniesDetails[_msgSender].isRegistered == false,
            "Company Already Registered on this Account"
        );

        for (uint256 index = 0; index < CompanyNamesList.length; index++) {
            require(
                keccak256(bytes(CompanyNamesList[index])) !=
                    keccak256(bytes(_Name)),
                "Company Name Already Exists"
            );
        }

        //adding to companydetails array
        CompaniesDetails[_msgSender] = CompanyDetail({
            Name: _Name,
            totalStocks: _totalStocks,
            stockPrice: _stockPrice,
            isRegistered: true,
            isApproved: false
        });

        //adding to list
        CompanyNamesList.push(_Name);
        CompanyFounderList.push(_msgSender);
    }

    function _approveCompany(address _CpnyAddr) external {
        require(
            CompaniesDetails[_CpnyAddr].isRegistered == true,
            "No such company registration request found"
        );
        require(
            CompaniesDetails[_CpnyAddr].isApproved == true,
            "Company is already approved"
        );
        CompaniesDetails[_CpnyAddr].isApproved = true;
    }

    //approve company implmented in  share market
}