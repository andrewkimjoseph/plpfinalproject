# SAApp - Engage to Convert
![image](https://user-images.githubusercontent.com/91619206/192979810-d3fe2837-110f-45ed-aeb3-b7648a7d388d.png)
_Figure 1: Splash screen of the app on Nokia 6.1 (Android 10)_
### LINK TO .APK FILE FOR ANDROID INSTALLATION: https://bit.ly/3SfUZSV

## PROBLEM STATEMENT
After engaging former and current sales agents of top loan-giving institutions in the country, I found out that 3 in every 5 of the agents are given generic loan repayment schedules to show prospective borrowers. Such a generic schedule looks like the one below:
![image](https://user-images.githubusercontent.com/91619206/193109678-e79ee53e-37da-4481-a01e-ece35d7b05af.png)

**However, the problem is that these generic schedules are only successful 40% of the time, since it is only 12 in 30 borrowers who actually take up a credit product.** That said, 86% of the agents agree that showing a loan repayment schedule to a client increases their chances of taking a loan, and, in this case, a specific one as opposed to the generic one you see above. Such a specific schedule looks like the one below:

![image](https://user-images.githubusercontent.com/91619206/193045738-aaa26ba6-6bb5-4fb6-9598-942490e9ea1b.png)
_Figure 3: Loan repayment schedule generated by the app, showing how a KES. 3,800,000 loan take at 12% reducing balance per year for 5 years_

Investopedia.com says: _Understanding the loan amortization schedule on a loan you are considering ... can help you see the big picture. By comparing the amortization schedules on multiple options, you can decide: 1. what loan terms are right for your situation, 2. what the total cost of a loan will be and 3. whether or not a loan is right for you_.

When asked how well they agree with Investopedia.com, the agents said 100%. It is with those findings that I decided to start the development of SAApp (Sales Agents App).

##### **Does the project have an economical or commercial benefit, and does it solve a problem?**

Yes. The work done on this prototype can be used to create a more complex, highly-functional, and beautifully-looking app that loan-giving institutions can purchase. When they pay for the product and have their agents trained on how to use it effectively, they will increase their chances of selling their credit products. Based on the research done, using this product will give a loan-giving institution an 80% chance of getting a borrower, which is 8 in every 10 people that the agents talk to. Therefore, the problem of agents only being successful 40% of the time will be addressed by the app's capabilities.


## PURPOSE OF THE PROJECT
1. Adding, viewing, and deleting clients (loan-giving institutions).

2. Adding, viewing, and deleting agents (who work for loan-giving institutions).

3. Adding and viewing referrals added by agents. In the app, a referral is anyone who is interested in taking a loan. Once an agent send their details, the client should continue the conversation with the referral.

4. Generating loan repayment schedules for prospective borrowers. The loans can either be fixed interest or reducing balance interest.

## TECHNICAL REQUIREMENTS OF THE PROJECT
PROGRAMMING LANGUAGE USED: **DART 2.18.2**

FRAMEWORK USED: **FLUTTER 3.3.3**, **FLUTTERFIRE**

CODING ENVIRONMENT: **VISUAL STUDIO CODE**

DATABASE SYSTEM: **FIREBASE REALTIME DATABASE (NoSQL)**

HOSTING PLATFORM: **NONE (Find .apk file link at the top)**

LOGO DESIGN: **CANVA**

## HOW THE APPLICATION WORKS
### LINK TO A VIDEO DEMONSTRATION OF HOW THE APP WORKS: https://drive.google.com/file/d/1rgGTqDBRo_p_MVxbcSUJl_ZYpBKjAkCb/view?usp=sharing

### HOME PAGE:
![image](https://user-images.githubusercontent.com/91619206/192981335-584602e2-956d-4a67-9791-18164511de7f.png)

### ADMIN (OR SAAPP END)
#### ADMIN LOGIN PAGE:
![image](https://user-images.githubusercontent.com/91619206/193101314-8f2473a6-2940-4b63-a296-0274f4760cbb.png)

#### SUCCESSFUL LOGIN TO ADMIN PAGE:
![image](https://user-images.githubusercontent.com/91619206/193101479-5d7670c8-c544-413a-bacb-508163ff244f.png)

#### ADD CLIENT SCREEN:
![image](https://user-images.githubusercontent.com/91619206/193101997-26cec2d6-2b45-40af-8d0c-6bb134635f3e.png)

#### ADDING CLIENT DETAILS:
![image](https://user-images.githubusercontent.com/91619206/193102058-c5f733d3-db09-49a5-9445-5cffabf715e9.png)

#### CONFIRMATION PROMPT FOR CLIENT DETAILS TO BE ADDED:
![image](https://user-images.githubusercontent.com/91619206/193102148-3ad9cc6e-d8d8-4073-86ce-a41ea921269a.png)

#### CLIENT DETAILS ADDED SUCCESSFULLY SNACKBAR:
![image](https://user-images.githubusercontent.com/91619206/193102199-61a54944-3c46-48a6-8122-3c09168cf752.png)

#### ALL CLIENTS ADDED SCREEN:
![image](https://user-images.githubusercontent.com/91619206/193102351-7490741c-7e94-4148-a00a-cd11d07324a1.png)

#### CLIENT DELETE SCREEN:
![image](https://user-images.githubusercontent.com/91619206/193102399-58672e4c-54c2-42df-bede-f69fd8e2da71.png)

#### CONFIRMATION FOR CLIENT DETAILS TO BE DELETED:
![image](https://user-images.githubusercontent.com/91619206/193102790-7a5d7b19-7fdd-4d8d-8231-14b8fb48d4a3.png)

#### PASSWORD CHANGING SCREEN
![image](https://user-images.githubusercontent.com/91619206/193102849-e5e36f27-30e7-4bd5-9c85-270bfb8e25e1.png)

### CLIENT END
#### CLIENT LOGIN PAGE:
![image](https://user-images.githubusercontent.com/91619206/193103580-a7e84988-e47f-4973-ba01-45a3b8c71b35.png)

#### CLIENT LOGIN DETAILS ENTERED:
![image](https://user-images.githubusercontent.com/91619206/193103616-aba6e696-6582-4537-a8d6-e02874cca31a.png)

#### SUCCESSFUL CLIENT LOGIN PAGE:
![image](https://user-images.githubusercontent.com/91619206/193103679-8bcb4204-b34a-4610-a007-15b70459de36.png)

#### ADD AGENT SCREEN:
![image](https://user-images.githubusercontent.com/91619206/193103774-12840c10-543a-4aad-9420-11ccd2f1dfc6.png)

#### AGENT DETAILS BEING ADDED:
![image](https://user-images.githubusercontent.com/91619206/193103829-c45fa752-3b79-4798-98cd-3ae498e35996.png)

#### CONFIRMATION PROMPT FOR THE AGENT DETAILS BEING ADDED:
![image](https://user-images.githubusercontent.com/91619206/193103984-bda18c9b-8d78-4747-a4b2-4d39d59dc98e.png)

#### AGENT DETAILS ADDED SUCCESSFULLY:
![image](https://user-images.githubusercontent.com/91619206/193104015-1e192d54-8a2d-46ee-a025-d0d82ab95698.png)

#### DELETE AGENT SCREEN:
![image](https://user-images.githubusercontent.com/91619206/193104701-2bc59592-8860-4ded-bbc8-11e3ce6f98b0.png)

#### CONFIRM AGENT TO DELETE SCREEN:
![image](https://user-images.githubusercontent.com/91619206/193104237-c7e20a65-6bfe-4d61-86c3-ba0675bea24a.png)

#### VIEW REFERRALS:
![image](https://user-images.githubusercontent.com/91619206/193108319-11da4783-b14f-430f-8b8b-48e55cb07227.png)

#### VIEW ALL AGENTS SCREEN:
![image](https://user-images.githubusercontent.com/91619206/193104352-c9dc0d6d-9a11-4532-9763-180eb7aaad5e.png)

#### CHANGE PASSWORD FOR AGENT SCREEN:
![image](https://user-images.githubusercontent.com/91619206/193104780-bc08564b-eec2-4503-b041-2d75c497c5be.png)

### AGENT END:
#### AGENT LOGIN PAGE:
![image](https://user-images.githubusercontent.com/91619206/193105504-7a28a330-89bb-4b3b-8c3a-51b3c12f7aad.png)

#### AGENT LOGIN SUCCESSFUL SNACKBAR:
![image](https://user-images.githubusercontent.com/91619206/193105548-f62cc3bd-db2e-498e-806c-2af930c46815.png)

#### CALCULATE LOAN SCREEN:
![image](https://user-images.githubusercontent.com/91619206/193105782-c986d4f5-ea3d-4c30-a28d-a1891893f7e3.png)

#### CALCULATE LOAN SCREEN, ADDING FIGURES (EXAMPLE A):
![image](https://user-images.githubusercontent.com/91619206/193105865-3cd918a0-6207-4b12-a99b-7a54b2b88708.png)
_A loan of 3,800,000 taken at 12% reducing balance interest for 5 years_

##### RESULTS:
![image](https://user-images.githubusercontent.com/91619206/193106057-43a2a7cb-aca3-447f-bea7-0bdd25f66602.png)
![image](https://user-images.githubusercontent.com/91619206/193106096-cfbcb71f-003d-4717-b702-8ab6cb8a4692.png)

#### CALCULATE LOAN SCREEN, ADDING FIGURES (EXAMPLE B):
![image](https://user-images.githubusercontent.com/91619206/193106259-e4b67907-36fb-4f27-80c1-88d32ea51913.png)
_A loan of 3,800,000 taken at 12% fixed interest for 5 years_

#### RESULTS:
![image](https://user-images.githubusercontent.com/91619206/193106582-8ccb9a42-ee70-4b54-aa90-9605bc57d71e.png)
![image](https://user-images.githubusercontent.com/91619206/193106612-439bc276-ec67-49bf-90b9-b5c0d5046c5b.png)

#### REFERRAL SCREEN:
![image](https://user-images.githubusercontent.com/91619206/193106674-34f61049-ef21-4fd7-91ba-42458daa4c0f.png)

#### ADDING REFERRAL:
![image](https://user-images.githubusercontent.com/91619206/193106696-bc1bea81-5654-472a-b2cc-1057183ec9bf.png)

#### CONFIRMATION PROMPT FOR ADDING REFERRAL:
![image](https://user-images.githubusercontent.com/91619206/193106802-5505e9ec-abf8-4927-bef1-cc2f84112e83.png)

### REFERRAL ADDED SUCCESSFULLY SNACKBAR:
![image](https://user-images.githubusercontent.com/91619206/193106827-f53bf876-92f1-41e7-aa19-f96adfeff53d.png)

### ALL REFERRAL ADDED SCREEN:
![image](https://user-images.githubusercontent.com/91619206/193107029-887c3010-1409-412f-a242-ff5194eb122d.png)

### PASSWORD SCREEN:
![image](https://user-images.githubusercontent.com/91619206/193107099-9013469f-9e4b-4329-ad35-852c34646018.png)
