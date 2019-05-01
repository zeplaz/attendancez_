/* 
 * File:   master_guest_list.cpp
 * revision number alpha.0.1.8.
 * 
 * Author: _zepalz//Matthew Edmund Duffy.
 * Authrzation; Orgburo.
 *
 * Created on November 13, 2017, 3:05 AM
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */
/*
 * usage, this file can be compiled on the school sysrem with the command  
 * > g++  m_l_main0.1.8.cpp   -lpq 
 * or set an output name,. 
 * run with ./a.out (or if you rename it at complie)
 * 
 * CLI is triggerd all information to use the programe are given, you will be brought to a switch 
 * selection note that ONLY function 1. works. the orginal ver. 0.8. was just this function, 
 * however now it is able to be re have a loop i re deisgned the switch and am in progress of working
 * on the guest-check in. never the less it is stable, and if you endup in option 2. it will just lead
 * to proper disconection and termination of the program.. not ideal but. its in dev. 
 * contunes with other functionality. ( i will also hence if the program goes out of bounds
 * it properly disconects and exitis
 * 
 * */

// libraryz

#include <cstdlib>
#include <iostream>
#include <iomanip>

#include <postgresql/libpq-fe.h>

            /*  #include <pqxx.h> ??  seems not to exist on school system i was able to like complie the whole 
                         thing on my system then track the files down redeign the foler and got it to work  
             *              on the shcool systme by moving whole libray and such but only after i 
             *      did the whole implimation with the libpq. sooo stuck with it but in futre 
             *      may explor this pqxx.              */
                                     // using namespace pqxx;

// namespaces
using namespace std;


// function defz
void userinputselect(char&); 
void welcome();
void conection();
void disconect();

int error(PGresult*);

void eventdisplay();
void displayguestlist(string);
void mastergl_display();
void guest_checkin();


//global vars
PGconn *conn;
int status; 

int main(int argc, char* argv[]) {
	
// main vars
    char userfunctionselect[2];
       

// loop to keep you inside the program. 
    welcome(); 
    do {
        
// Welcome uses a pass by ref to get user input,  
      
        
                          
       userinputselect(*userfunctionselect);    
   
   
        
    /** 
    * switch controls the selected utility will be very useful when a UI is added.
    *
    * case 1: is the "master-guest-list utility here you can get detailed information about 
    * guest names of attending, if they are their etc.. should add a total num and break down.. 
    * 
    * case 2: (in devlopmentmnt currntly will tell you if a ticket is already in use. or not.
     * no updates occure. 
    * 
    * case 3: \(not implimited yet\) coat check. 
     */
        
        
    switch (*userfunctionselect){
           
          case '1': 
                   mastergl_display();
                  
         break ;
                 
          case '2': 
             
              guest_checkin();
     
         break;
         
           case 'q':
               break;
           
        default : cout << endl << "This is not a valid option, to quit type \"q\"" << endl; 
    }}
    while (*userfunctionselect != 'q');   
   
    
    
//proper shutdown procesdure. 
    
    if(*userfunctionselect == 'q')
      
        cout << endl <<"now disconecting" <<endl; 
    disconect();  
        cout << "now existing byezz!";
    
    return 0 ;
    
    
// other escape function shutdown     

    cout << endl <<" inproper termination; now disconecting" <<endl; 
    disconect();  
    cout << "now existing";
    return 1;
}


// functions! wooo. 


/*
 
 */
void conection () { 
    string userpassword; 
    string username;
    string loginprep;
  
    cout << "Please Input Your Database Username: ";
    cin >> username;
    cout << "\n" "Please Input Your Database Password: ";
    cin >> userpassword;
        
    // Conection attempt 
       
    loginprep= "dbname=mduffy host=localhost user=";
    loginprep +=username;
    loginprep += " password=";
    loginprep += userpassword;
  
    conn = PQconnectdb(loginprep.c_str());
   
    if (PQstatus(conn) == CONNECTION_BAD) {
		puts("We were unable to connect to the database");
		exit(1);
	}     
    
     // Sets the search_path for attendants   
    PGresult *res; 
    res = PQexec(conn, "set search_path to attendants");
    PQclear(res);
}


void disconect() {    
     PQfinish(conn);
    }


int error(PGresult *res) {
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
		puts("We did not get any data!");
           exit(2);
    return(1);
    }
else return 0;
}


void welcome() {
	printf( "\n Welcome to Master GuestList\n \n");
        conection(); 
 
}   

/*
 
 */

void mastergl_display()

{ 
    string mgl_id_event;
    

   
        
       
     /// displays the avilable events///
    eventdisplay(); 
    
	/////////////   captures user input for event ID SHOULD HAVE ERROR HANDLING! as well as other options!! 
    cout << endl<<"please Enter the Event_id of the Event you wish to search and press Return" <<endl;
    cin >> mgl_id_event;
    cout << endl<< "Processing... \n" << endl;
              
    ///////////// 
       
    displayguestlist(mgl_id_event);
    }

/*
 
 */

void displayguestlist (string mgl_id_event) {
    int row; 
    int col;
    int rec_count;
    string pr_querry;
    PGresult *res;
    PGresult *resname;
            
    //gets name of event being querryed
    pr_querry ="select e_name from events where id_event = "+mgl_id_event;    
        
	resname = PQexec(conn, pr_querry.c_str());
    
    //builds Guestlist 
    pr_querry = "select attend, ticket_number, e_name, g_name  from guest_list join events "
            "on guest_list.frkey_id_event= events.id_event join guests on frkey_id_guest = guests.id_guest where id_event = ";
    pr_querry += mgl_id_event;
    res = PQexec(conn, pr_querry.c_str());
    status =error(res); 
    rec_count = PQntuples(res);
 
    //prints the gustList    
	printf("We received %d Guests Records for the Event: ", rec_count);
    printf(PQgetvalue(resname, 0, 0));
    puts ("\n");
     
    puts("===============================================================");
    puts("---:attended:----TicketNumber-------EventName-------GuestName--- ");
  
	 for (row = 0; row < rec_count; row++) {
                for (col = 0; col < 4; col++) {
					printf("%12s\t", PQgetvalue(res, row, col));
				}
				puts("");
	}

	PQclear(res);
    PQclear(resname);
}

/*
 
 */

void eventdisplay() {
    int row; 
    int col;
    int rec_count;
    
    PGresult *res;
    
    cout <<"\n Event Display utility \n"; 
   
        res = PQexec(conn, "select id_event, e_name from events");
    status =error(res);                    
        rec_count = PQntuples(res);
    
    cout << endl<< "|-|list of avalable events to check Master-Guest-list|-|\n";
    
    puts("Event_ID|-|Event_Name========");  
      
    for (row=0; row<rec_count; row++) {                 
           for (col = 0; col <2 ; col++) { 
				printf("%s\t   ", PQgetvalue(res, row, col));}
				puts("");
	}
    
    puts("============================= \n");

    PQclear(res);
}


void guest_checkin(){
   
    PGresult *res; 
    
    string queryprep; 
    
    string ticketnumber;
    string guestname;
    bool attendstatus = false; 
    
          
    cout << ""; 
        
    cout << "Please enter the guest's ticket number and press return: "; 
        
    cin >> ticketnumber;
  
    queryprep =  "select attend from guest_list where ticket_number = "  ;
    queryprep +=  ticketnumber;
   
      
    res  = PQexec (conn, queryprep.c_str());    

    status = error(res);
                                                      
  
    attendstatus = PQgetvalue(res,0,0);
    
                
   if (attendstatus == true)
     {
    queryprep= "select g_name from guest_list join guests on frkey_id_guest = guests.id_guest "
               "where ticket_number = "+ticketnumber; 
   
    res  = PQexec (conn, queryprep.c_str());    
    status = error(res);           
                       
       cout << endl<<  "The Ticket has already been signed in.."
     <<  " please insure ticket holder is correct person: " << PQgetvalue(res, 0,0) << endl; 
                                 }
    
    if (attendstatus == false){ cout << endl << "it would appear the " << 
            "person has not come yet.. more functions will come soon :)" << endl ;}
                //res  =   PQexec (conn, "update into guest_list set attend ='true' " );
    
}


   void userinputselect(char &userfunctionselect)  {   
   
       cout << endl << "To enter Master-Guest-List utility type \"1\"|-|-| "
            << "To enter Guest check-in type \"2\"|-| press return: " ;
       
     cin >> userfunctionselect; 
   }