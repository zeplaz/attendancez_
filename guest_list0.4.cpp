
/* 
 * File:   master_guest_list.cpp
 * Author: zepalz
 *
 * Created on November 13, 2017, 3:05 AM
 */

// libraryz
#include <cstdlib>
#include <iostream>
//#include <pqxx/pqxx>  ?? NOT ABLE TO FIND THIS ON SCHOOL COMPLIER! SHOULD BE ADDED!!

 #include <postgresql/libpq-fe.h>


//using namespace pqxx;
using namespace std;


// main 

// function defz
void welcome(); 
void conection();
int  error(PGresult);
void disconect();

void eventdisplay();
void displayguestlist(string);

//global vars
PGconn *conn;
int status; 

int main(int argc, char* argv[]) {
    
    
    string mgl_id_event;
   
    // Welcome and conection;
         welcome();
       conection();
       
     // Sets the search_path for attendants   
    
    PGresult *res; 
    res = PQexec(conn, "set search_path to attendants");
    PQclear(res);
        
    /// displays the avilable events///
    eventdisplay(); 
              
   ///////////////   captures user input for event ID SHOULD HAVE ERROR HANDLING! as well as other options!! 
       cout << "please Enter the Event_id and press Return" <<endl;
       cin >> mgl_id_event;
       cout << endl<< "Processing... \n" << endl;
              
      ///////////// 
       
    displayguestlist(mgl_id_event);
     
     disconect();  
     
     return 0;
     }


void conection ()
{
   // Conection attempt 
    conn = PQconnectdb("dbname=mduffy host=localhost user=mduffy password=ChangeMe17-9");
   
    if (PQstatus(conn) == CONNECTION_BAD) {
    puts("We were unable to connect to the database");
    exit(1);
      }
         
}

void disconect()
{    
    PQfinish(conn);
    
}


int error(PGresult *res)
{
 
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
            puts("We did not get any data!");
            
         exit(2);
          return(1);
    }
    else return 0;
}


void eventdisplay()
{
    int row; 
    int col;
    int rec_count;
    
    PGresult *res;
       { 
      
    res = PQexec(conn, "select id_event from events");
   status =error(res); 
    cout << "The events you can select are:" << endl;
    
    
    res = PQexec(conn,"select id_event, e_name from events");
    status =error(res); 
    
    rec_count = PQntuples(res);

     }
    puts("===========================");  
    for (row=0; row<rec_count; row++) 
    {                 
           for (col=0; col<2; col++)
           { printf("%s\t   ", PQgetvalue(res, row, col));}
           
            puts("");
     }
    puts("========================== \n");

    
    PQclear(res);
}

void displayguestlist (string mgl_id_event)
{
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
    pr_querry = "select attend, ticket_number, e_name, g_name  from guest_list join events on guest_list.frkey_id_event= events.id_event join guests on frkey_id_guest = guests.id_guest where id_event = ";
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
  for (row=0; row<rec_count; row++) {
                for (col=0; col<4; col++) {
                     printf("%12s\t", PQgetvalue(res, row, col));
            }
              puts("");
      }

     
     PQclear(res);
     PQclear(resname);
     
}

void welcome()
{printf( "Welcome to Master GuestList \n \n");}

   