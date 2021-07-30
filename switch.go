package main

/* Imports
 * 4 utility libraries for formatting, handling bytes, reading and writing JSON, and string manipulation
 * 2 specific Hyperledger Fabric specific libraries for Smart Contracts
 */
import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	"strconv"

	sc "github.com/hyperledger/fabric-protos-go/peer"
)

type SmartContract struct {
}

type Account struct {
	AccountName    string  `json:"account_name"`
	AccountNumber  string  `json:"account_number"`
	AccountBalance float64 `json:"account_balance"`
}

// Init method is called when the Smart Contract "switch" is instantiated by the blockchain network
// Best practice is to have any Ledger initialization in separate function -- see initLedger()
func (s *SmartContract) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	return shim.Success(nil)
}

// Invoke method is called as a result of an application request to run the Smart Contract "switch"
// The calling application program has also specified the particular smart contract function to be called, with arguments
func (s *SmartContract) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {

	// Retrieve the requested Smart Contract function and arguments
	function, args := APIstub.GetFunctionAndParameters()
	// Route to the appropriate handler function to interact with the ledger appropriately
	if function == "queryAccount" {
		return s.queryAccount(APIstub, args)
	} else if function == "initLedger" {
		return s.initLedger(APIstub)
	} else if function == "createAccount" {
		return s.createAccount(APIstub, args)
	} else if function == "queryAllAccounts" {
		return s.queryAllAccounts(APIstub)
	} else if function == "changeAccountName" {
		return s.changeAccountName(APIstub, args)
	} else if function == "depositFunds" {
		return s.depositFunds(APIstub, args)
	} else if function == "withdrawFunds" {
		return s.withdrawFunds(APIstub, args)
	}

	return shim.Error("Invalid Smart Contract function name.")
}

func (s *SmartContract) queryAccount(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	accountAsBytes, _ := APIstub.GetState(args[0])
	return shim.Success(accountAsBytes)
}

func (s *SmartContract) initLedger(APIstub shim.ChaincodeStubInterface) sc.Response {
	accounts := []Account{
		Account{AccountName: "Elizabeth Adegbaju", AccountNumber: "2174935757", AccountBalance: 50000.00},
		Account{AccountName: "Adeotun Adegbaju", AccountNumber: "0461049979", AccountBalance: 70000.00},
	}

	i := 0
	for i < len(accounts) {
		fmt.Println("i is ", i)
		accountAsBytes, _ := json.Marshal(accounts[i])
		err := APIstub.PutState("ACC"+strconv.Itoa(i), accountAsBytes)
		if err != nil {
			return shim.Error(err.Error())
		}
		fmt.Println("Added", accounts[i])
		i = i + 1
	}

	return shim.Success(nil)
}

func (s *SmartContract) createAccount(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 5 {
		return shim.Error("Incorrect number of arguments. Expecting 5")
	}

	accountBalance, _ := strconv.ParseFloat(args[3], 64)
	var account = Account{AccountName: args[1], AccountNumber: args[2], AccountBalance: accountBalance}

	accountAsBytes, _ := json.Marshal(account)
	err := APIstub.PutState(args[0], accountAsBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func (s *SmartContract) queryAllAccounts(APIstub shim.ChaincodeStubInterface) sc.Response {

	startKey := "ACC0"
	endKey := "ACC999"

	resultsIterator, err := APIstub.GetStateByRange(startKey, endKey)
	if err != nil {
		return shim.Error(err.Error())
	}
	defer resultsIterator.Close()

	// buffer is a JSON array containing QueryResults
	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return shim.Error(err.Error())
		}
		// Add a comma before array members, suppress it for the first array member
		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString(",")
		}
		buffer.WriteString("{\"Key\":")
		buffer.WriteString("\"")
		buffer.WriteString(queryResponse.Key)
		buffer.WriteString("\"")

		buffer.WriteString(", \"Record\":")
		// Record is a JSON object, so we write as-is
		buffer.WriteString(string(queryResponse.Value))
		buffer.WriteString("}")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("]")

	fmt.Printf("- queryAllAccounts:\n%s\n", buffer.String())

	return shim.Success(buffer.Bytes())
}

func (s *SmartContract) changeAccountName(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	accountAsBytes, _ := APIstub.GetState(args[0])
	account := Account{}

	err := json.Unmarshal(accountAsBytes, &account)
	if err != nil {
		return shim.Error(err.Error())
	}
	account.AccountName = args[1]

	accountAsBytes, _ = json.Marshal(account)
	err = APIstub.PutState(args[0], accountAsBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func (s *SmartContract) depositFunds(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	accountAsBytes, _ := APIstub.GetState(args[0])
	account := Account{}

	err := json.Unmarshal(accountAsBytes, &account)
	if err != nil {
		return shim.Error(err.Error())
	}
	amount, _ := strconv.ParseFloat(args[1], 64)
	account.AccountBalance += amount

	accountAsBytes, _ = json.Marshal(account)
	err = APIstub.PutState(args[0], accountAsBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func (s *SmartContract) withdrawFunds(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	accountAsBytes, _ := APIstub.GetState(args[0])
	account := Account{}

	err := json.Unmarshal(accountAsBytes, &account)
	if err != nil {
		return shim.Error(err.Error())
	}
	amount, _ := strconv.ParseFloat(args[1], 64)
	account.AccountBalance -= amount

	accountAsBytes, _ = json.Marshal(account)
	err = APIstub.PutState(args[0], accountAsBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func main() {

	// Create a new Smart Contract
	err := shim.Start(new(SmartContract))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
