## INTRODUCTION:
    
This is a system designed to revolutionize the Supply chain Management of perishable produce. Denso provides cutting-edge technology to maintain the freshness of the product over time till it reaches the end-consumer, through its cooling facility equipped package boxes. DSCS is a system to maintain an immutable database of all the transactions and their status at any point of time. Denso aims to generate revenue based on the quality of produce maintained in their system, for which they maintain a contract between all the players of the Supply Chain model.

### Benefits

1.  This system, which is supported by an immutable database of the freshness scores of the products delivered in Denso’s cooling boxes, contains the location and temperature information of all the products at all points of time. This enables the traceability of the condition of an order.
    
2.  The Rating and Feedback mechanism in the system allows Denso to set a payment contract with all the players of the supply chain. This enables Denso to generate revenue.
    

### Requirements from DSCS
The central technical requirements for the system are :

#### 1.  Traceability:
    
Traceability of the goods during the delivery, ensuring the freshness of the products that reach the end consumer. This will increase Denso’s revenue.

#### 2.  Untamperablilty:
    
The data from sensors that continuously monitor the goods to be delivered must be available to all interested parties and should be unmodifiable by the service provider.

#### 3.  Restricted Data Access:
    
The data corresponding to a particular order must only be accessible to parties involved in that transaction and not all data is visible to
everyone involved in the transaction.

#### 4.  Limited input data:
    
Since such a service provider has to bargain delivery data from sellers, the data required to operate the system must be minimal.**

*Data Flow Overview*
![](https://lh5.googleusercontent.com/r8KNwcXQV4gtMAoaMvMdMisuujkKoexn4HBxXSH1R2mgHRhlYfs1ImmkmilqdccHq6gF0AvLXjopjVMkwRHaSdLsHI45YB6kMmDLIPec-I6U9MdEzjGIJXqphXP_BJm1nYnbO6LS)**



> Denso-net is a basic implementation of a Blockchain-enabled end-to-end supply chain system, powered by Hyperledger Fabric. 

## Assumptions:
* This network has been developed based on Hyperledger fabric v2.2.
* The current setup assumes 2 organizations in a Hyperledger Fabric blockchain setup, namely, Denso and Shipper (an alias for a general shipper).
* Each of the organization currently supports only 1 peer and 1 user each.  
* One channel exists between Denso and shipper peers, called mychannel in the implementation. 
* Hyperledger fabric tool fabric-ca-client is used for certification authority. This is important to consider during commercial deployment. 

## Testing the system:
1. Clone this repository and extract it into a folder contained in a folder which contains Hyperledger Fabric **v2.2** setup. Check out this [link](https://hyperledger-fabric.readthedocs.io/en/release-2.2/install.html) for the pre-requisite installation instructions. It is important to ensure that the extraction of this project is done as a folder in the folder containing Fabric binaries. This is because, a binary by the name of *test-network* alread exists, which is not to be used in the run of this project.  
2. Open the folder *Final_densonet* in a terminal. 
### Setting up the network:
Execute the command: ``` ./network-starter.sh``` in the current folder. This command will setup the network, with peers, orderer(s), channel(s). 
1. Currently, there are 2 peers, one peer each for Denso and Shipper, and one orderer. 
2. There is one channel called mychannel. It connects the 2 peers. The 2 peers are also the anchor peers for their respective organizations. 
3. All the processes are currently designed to run in separate Docker containers. 
4. After setting up the network, the status of the docker containers can be checked by executing ```docker ps -a```. 
5. The logs of any of the container processes can be checked by executing ```docker logs {container_ID}```, and the desired verbosity can be mentioned. 
### Setting up the Chaincode:
Setting up the Chaincode containers and committing them to the channel. 
1. In order to avoid a highly customized and hence unscalable shell script, let's resort to actual commands and make them more customizable. A shell script can        be created at any time, as per the needs. 
2. The following tells the commands to be executed to package, install, approve and commit a chaincode. The user is assumed to be in the main project directory and not in any sub-directories before going to the next step. 
3. ``` 
      cd organization/Shipper
      source Shipper.sh
      peer lifecycle chaincode package cp.tar.gz --lang node --path ./contract --label org.densonet.order
      peer lifecycle chaincode install cp.tar.gz
      peer lifecycle chaincode queryinstalled
      export PACKAGE_ID={chaincode_ID obtained from above cmd}
      peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name ordercontract -v 0 --package-id $PACKAGE_ID --sequence 1 --tls --cafile $ORDERER_CA
      cd ../Denso
      source Denso.sh
      peer lifecycle chaincode package cp.tar.gz --lang node --path ./contract --label org.densonet.order
      peer lifecycle chaincode queryinstalled
      export PACKAGE_ID={chaincode_ID obtained from above cmd}
      peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name ordercontract -v 0 --package-id $PACKAGE_ID --sequence 1 --tls --cafile $ORDERER_CA
      peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --peerAddresses localhost:7051 --tlsRootCertFiles ${PEER0_ORG1_CA} --peerAddresses localhost:9051 --tlsRootCertFiles ${PEER0_ORG2_CA} --channelID mychannel --name ordercontract -v 0 --sequence 1 --tls --cafile $ORDERER_CA --waitForEvent
      ```
4. This installation and committing is needed initially after setting up of the network and each time a new chaincode is desired to be committed. The sequence should appropriately reflect the number of the chaincode committed.

#### End-User

1. *Places Orders*
 2.  *Access Freshness Information*
 
#### Shipper
 1. *Shipper provides premium delivery options for its products fulfilled
    by Denso.*
 2. *It hires Denso’s services to maintain the freshness of its products and may demand higher prices from the end consumer.*

#### Hub Manager
1. *Assigns cooler boxes and Drivers to orders.*

#### Tag Box
1. *Provides Sensor data about delivery conditions.*
#### DENSO
1. *Monitors the delivery conditions.*
### Executing Processes for the order transactions.
After completing the network setup and chaincode installation on channel, we are ready to experiment, by creating different orders in the system. The following implementation is just a dummy implementation, which can be used as a reference. It is suggested that 2 parallel terminals be operated, one with the Shipper's environment variables and another with Denso's environment variables.
1. In one terminal, move to folder "organization/Shipper" and execute ``` source Shipper.sh```. This will set the environment variables for Shipper. 
2. In another terminal, move to folder "organization/Denso" and execute ``` source Denso.sh```. This will set the environment variables for Denso.
3. Move to the application folders in each of the terminals by ```cd application```. 
4. In both the terminals, execute ``` node addToWallet.js``` command. This will add the identities "balaji" and "isabella" to users from Denso and Shipper organizations respectively, if they are not already added. The console output ```done``` is the most likely response. 
5. In both the terminals, execute ``` node enrollUser.js``` command. This will enroll the identities "balaji" and "isabella" to users from Denso and Shipper organizations respectively, if they are not already enrolled. When executed after addToWallet, the following console output is probable (the directory mentioned is according to my machine's file structure):
    ```
    Wallet path: /home/dell/ishahlf/fabric-samples/Final_densonet/organization/Shipper/identity/user/isabella/wallet
    An identity for the client user "user1" already exists in the wallet
    ```
*Final Design Iteration for transaction flow*
**![](https://lh3.googleusercontent.com/Puk-_B6a0YtuWJpwA7c6aH1zRW8hhjj2Di-W7MlnJMXaTVeMfS7HAeU4ZY-Kxpw3UsehHWoJOb9WD07Zj_YsavmZEEJlun_JJrjkdOqOuLxvehAgjPILVf5PTnNmKyVOVmdA-tML)**
## Detailed Explanation of Transaction Flow-

### Pre-conditions

1.  Only single Shipper and Hub Manager Organizations are there in the model. This model is not currently scaled for multiple competitive organizations’ consortium.
    

  

###  Channels in the Blockchain system

1.  Channel 1: This channel consists of all the Shipper peers and Denso. Ordering service: Denso Peers
    
2.  Channel 2: This channel consists of Shipper peers, Denso peers, and Tag Box peers. Ordering service: Denso Peers
    
3.  Channel 3: This channel consists of some of the Denso peers and all of the Hub Manager peers. Ordering service: Denso Peers
    

 ### The Process

1.  The consumer, who possesses the shipper’s mobile app for the purchase, places an order through it for an available quantity of produce.
    
2.  The shipper provides important delivery information (Delivery address, Hub ID, and Order ID) to Denso via Channel 1.
    
3.  The shipper’s peers send the above transaction to the Ordering service which packages it with other transactions to form a block of transaction. The information about this order can be read by the Denso peers (assumed to be constantly ‘listening’ for updates and new orders).
    
4.  Shipper sends the delivery information to the Hub manager ( Outside blockchain layer ).
    
5.  The HM provides important delivery information (Cooler ID and Order ID) to Denso via Channel 3.
    
6.  The HM’s peers send the above transaction to the Ordering service which packages it with other transactions to form a block of transaction. The information about this order can be read by the Denso peers (assumed to be constantly ‘listening’ for updates and new orders).
    
7.  The Tag Box of Cooler ID associated with order uploads the tracking data (Temperature, Lid Openings) to channel 2.
    
8.  The Tag Box’s peers send the above transaction to the Ordering service which packages it with other transactions to form a block of transaction. The information about this order can be read by the Denso and Shipper to know the condition of delivery(assumed to be constantly ‘listening’ for updates and new orders).
    
9.  Denso monitors signals from the driver’s app to get location, route, and driver behavior information. (Third-party apps: out of scope)
    
10.  Denso generates the freshness scored based on an external algorithm. Denso client application proposes a ledger update with the freshness score in Channel 1. The client application packages it into a proposal and submits it to Denso’s and Shipper’s peers for endorsement.
    
11.  After receiving the endorsements, a transaction is created by Denso’s client application and submitted to the ordering nodes for inclusion into a block to be distributed to the Channel 1 peers for inclusion in their ledger.
    

  

Denso will charge for services as per the Freshness score from the shipper
#### Initiate an order
An order can be initiated by a shipper. Both the peers on the channel need to approve the order, for it to get committed to the Blockchain ledger and world state. From the terminal dedicated to the Shipper folder, execute ``` node initiate.js```. Enter the Shipper name and order ID, when prompted for these details. This sets the order state to 1. The following output will indicate success:
    ```
    Transaction complete.
    Disconnect from Fabric gateway.
    Initiate program complete.
    ```
* Real-time query terminals can be optionally activated in 2 other terminals for constant inspection of the world state, as seen by the 2 peers. To enable this functionality, run the command with the appropriate command line arguments ```bash query_denso.sh {SHIPPER_NAME_FOR_ORDER} {ORDER_ID_FOR_ORDER} {TIME_BETWEEN_SUCCESSIVE_POLLING_ATTEMPTS}``` on one terminal and ```bash query_shipper.sh {SHIPPER_NAME_FOR_ORDER} {ORDER_ID_FOR_ORDER} {TIME_BETWEEN_SUCCESSIVE_POLLING_ATTEMPTS}``` on other terminal. 
#### Starting Delivery
And hence publishing the Cooler Box and Hub Manager IDs onto the Blockchain ledger is done by Denso. On the terminal, with the Denso's application folder open, run ```node publish_ids.js```. When prompted, enter the Shipper name and order ID, to locate the order. Enter the Cooler Box ID and Hub Manager ID next. This can be run only after initiating a legitimate order, to avoid running into any errors. This sets the order state to 2. The delivery process cannot be started multiple times for the same order. A response similar to the following indicates success:
    ```
      Process Set IDs response.
      A order : 1 successfully set with Cooler Box ID 2 and Hub Manager ID 3
      Transaction complete.
      Disconnect from Fabric gateway.
      Set Cooler Box and HM IDs program complete.
    ```
#### Updating Cooler Box Temperature
This can be done by Denso user, only after the start of the delivery process and before the end of the delivery process is registered. Precisely, the state of the order must be 2, at the time of publishing the Temperature. Temperature information can be updated any number of times, within the constraint mentioned above. The state of the order doesn't change by updating the temperature. The temperature can be updated from the Denso/application terminal by running ``` node publish_temp.js```. When prompted, the shipper, order ID and temperature information can be entered. A console output similar to the following indicates success. 
  ```
  Process Set Temperature response.
  A order : 1 successfully set with Cooler Box Temperature 15
  Transaction complete.
  Disconnect from Fabric gateway.
  Set Cooler Box Temperature program complete.
  ```
#### Ending the Delivery Process 
The delivery process for an order can be ended only once, after the order delivery has been started. The state of the order is changed to 3. Run ``` node Del_end.js``` from the Denso/application terminal. A response similar to following indicates success:
```
Process Delivery end response.
A order : 1 Delivery ended successfully
Transaction complete.
Disconnect from Fabric gateway.
Set Delivery end program complete.
```

#### Completing the order
The order can be marked as completed by the Denso user, only once, after the order's delivery is marked ended. The state of the order changes from 3 to 4. Run ``` node Complete.js``` from the Denso/application terminal. A response similar to following indicates success:
```
Process order complete response.
A order : 1 Completed successfully
Transaction complete.
Disconnect from Fabric gateway.
Set Order Completion program complete.
```

#### Publishing Freshness Score
The Freshness score of an order can be published only after the order is completed, by the Denso user. The state of the order changes from 4 to 5, after the first input of Freshness score. Freshness Score can be updated any number of times, before publishing the payment, as requested by the Shipper. Run ``` node publish_FS.js``` from the Denso/application terminal. Enter the Shipper name, order ID and Freshness score when prompted. A response similar to following indicates success:
```
Process Set Freshness Score response.
A order : 1 successfully set with Freshness Score 75
Transaction complete.
Disconnect from Fabric gateway.
Set Freshness Score program complete.
```

#### Publishing Payment
The Payment of an order can be published only after the order Freshness Score is updated. The Shipper User requests to publish the payment. This is a one-time option. The state of the order changes from 5 to 6, after the payment gets published. Run ``` node publish_payment.js``` from the Shipper/application terminal. Enter the Shipper name and order ID when prompted. A response similar to following indicates success:
```
Process Calculate Payment response.
A order : 1 successfully set with Payment 20 with Freshness Score 75
Transaction complete.
Disconnect from Fabric gateway.
Set Payment program complete.
```
Currently, a simple Conditional Operator is determining the payment. 
``` let pay = (order.FS > 50) ? 20 : 10; ``` 
An oracle payment determination algorithm may take its place, as per the need. This is a part of the smart contract and as a result, it needs to be agreed by all the involved organizations. 

## Further Scope
This implementation has opened up several possibilities to improvise and make a production ready system. Some of them are listed below. 

- [ ] Implementational Challenges:
   -  [ ] Scaling up the system to handle multiple Shipper organizations. Issues of Channel management and collaboration between channels can come up. Will need a global database. 
   -  [ ] Including multiple peers, orderers, which calls for efficient Message passing and Distributed system management (for Fault Tolerance). 
   -  [ ] Including other players involved in the delivery process, depending on how crucial their role is in determining preserving trust, non-repudiation, privacy, completeness.
   -  [ ] API calls can be made to extract Real-time data from third-party organizations involved in the process. 
   -  [ ] UI for various users can be designed and the DApps can be invoked. 
   -  [ ] User identity mixing for better user anonymization (idemixer from HLF). 
   -  [ ] Experimenting with different Databases, to get the best possible properties. Can escalate to BaaS such as Firebase. 
   -  [ ] To enable better synchronization, Kubernetes clusters could be created on top of the Docker containers used. 
   -  [ ] Real CAs can be incorporated. (Not a real challenge, though)
   -  [ ] Hosting on PaaS 
   -  [ ] Using Private Data Collections effectively. Enabling Gossip (encrypted)
   -  [ ] Changing permissions and adding ACLs, both on system configuration update level and on the smart contract and DApp access level. 
   -  [ ] _Just for Experimentation purpose_ Try changing the System chaincodes, and incorporate finely engrained features. 
   -  [ ] Implementing a payment gateway for the customer (shipper), using Hyperledger Iroha. 
   -  [ ] Hyperledger Cello can be integrated for "as-a-platform" services and deployment ease. (implementation details not known)
   -  [ ] Hyperledger Grid can be used for an end-to-end, easy system implementation for supply chain management. 
   -  [ ] Have Apache Kafka for Ordering service management. 
- [ ] Research challenges:   
   -  [ ] Payment determination algorithm can be made more sophisticated. It can be called externally. It can be a neural network. MLOps + DevOps 
   -  [ ] Dynamically evolving, Real-time network configuration can be challenging to handle.
   -  [ ] Differential Privacy integration. 
   -  [ ] Federated Learning integration + Recommender Systems for Distributed Learning 
   -  [ ] Intrusion Detection System integration. This is especially important when interacting with third-party applications. Anomaly Detection and Misuse Detection
   -  [ ] Smart contract verification, for mutual trust between different parties involved.  
   -  [ ] The Freshness Scoring Mechanism can be an oracle. This can be separately developed as an image-processing + User Feedback sentiment analysis predictors. These + the delivery time parameters + User feedback, which are constantly monitored, can be blended in the best possible way. One possible way is using the user assigned Freshness scores as labels, which need to be eventually learnt, using the features from the various data sources. 
   -  [ ] _Way Beyond_: Automatic Smart contract generation, based on previous interactions of organizations. 
   -  [ ] In a highly scaled-up network infrastructure, an efficient Channel garbage collection system. So as we may have organizations entering and leaving the consortium, can we optimize our resources. 
   -  [ ] _Highly needed_ Automatic HLF network code upgradation system, as the HLF version changes (drastically and literally dramatically). Upgrading to the latest distribution of HLF 
   -  [ ] The Cryptographic library, Hyperledger Ursa can be used for enhancing Fabric. 

## Contact
On spotting any error or to provide any comments or suggestions, please feel free to [email me](mailto:Isha.Chaudhary.ee318@ee.iitd.ac.in). 

## Acknowledgement
I would like to sincerely thank my supervisor [Prof. Subodh Sharma](https://subodhvsharma.github.io/), for his constant guidance and support. Special thanks to Denso.org for giving us such an interesting problem statement to work on and giving out details and clarifications from time-to-time. 
I would also like to thank all of my collaborators for helping me in the project. 
