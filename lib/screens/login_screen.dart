import 'package:flutter/material.dart';
import 'package:green_market/screens/signin_screen.dart';



class Login extends StatelessWidget {
 
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
  
      return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset("assets/images/Background.jpg"),
            ),
         //   SizedBox(height: MediaQuery.of(context).size.height * 0.000001),
          const Text(  "LOGIN", 
            style: TextStyle(fontSize: 20,
            letterSpacing: 3,
            fontStyle:FontStyle.normal ,
            color: Colors.black, 
            fontWeight: FontWeight.bold),
             ),

               SizedBox(height: MediaQuery.of(context).size.height * 0.01),

         Container(
            width: MediaQuery.of(context).size.width * 0.85,
           child: Form(child: Column(
           children: [
             TextField(
               
               decoration: InputDecoration(
           
                 labelText: "Username",
                 hintText: "Enter your username",
                 prefixIcon: Icon(Icons.email),
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),
               ),
             ),
             SizedBox(height: 20),
             TextFormField(
              
               decoration: InputDecoration(
                 labelText: "Password",
                 hintText: "Enter your password",
                 prefixIcon: Icon(Icons.lock),
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),
               ),
             ),
             SizedBox(height: 20),
             ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 12, 231, 99),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
               onPressed: () {},
               child: Text("Login"),
               
             ),
             SizedBox(height: 20),
             Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text("Don't have an account?"),
                 TextButton(
                   onPressed: () {
                 Navigator.push( context,
                  MaterialPageRoute(builder: (context) => const Signin(),));
               },
                   child: Text("Create an Account"),
                 ),
               ],
             ),
           ],
           
           
           ),    
           ),
         ),
           


          ],
        ),
      ),
    );
    
    
  }
}
