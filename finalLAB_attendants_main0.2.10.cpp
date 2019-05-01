/* 
 * File:   attendants_main0.2.10.cpp
 * revision number alpha.0.2.10.
 *
 * Author: _zepalz//Matthew Edmund Duffy.
 * Authrzation; Orgburo.
 *
 * Created on November 13, 2017, 3:05 AM
 *  *
 */
/*
 * usage, this file can be compiled on the school linux sysrem with the command
 * > g++  attendants_main0.1.10.cpp   -lpq
 * or set an output name,.
 * run on terminal with ./a.out (or if you rename it at complie)
 * works on a CLI, for now (future plans for a UI)
 *
 * id like to add a bunch more stuff to this (inlcuding adding more tickets, and re-designing
 * program to be in proper c++ class-service, OO deign.. buttt. i just rushed to test and
 * get these fetures working, been sick and very bussy end of semster. howevr. this program
 * does update a log, and allows you to check in tickts.
 *
 * welcome will ask your name (emplo name), primisson class and for user name and pass.
 * (this feture is for school only, ideal i want to have login conections via, diffrent users
 * on the database but as we are not aurhotize to create new users, i use this workaround
 * ) mickey has granted primssions for the right tables, howver, in practice youd use your
 * empoli log name, pass and it would conect you with the appropate restrictions,
 * the program will ask you for your "primission class" this would later be set
 * to emploi id. but for showing the fetures of restriction. floor and gm can use the
 *  "master guest list feture. DOOR can not! all levels can check guests you need to know
 * ticket numbers to log in people, for example 28, or 18058816155, (are vaild
 * tickets that can be tested ) (ovlzy you cant see a * ticket num without having
 * the ticekt infront of you. check in a guest will change the attend
 * to true. ALSO, each time you log in your asked for a name, this name is loged into emploi_records
 * as well as the log in time. if you properly quit it logs the logout time. as well as your
 * authorization class.
 *
 *
 *
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
void welcome(string&);
void conection();
void disconect();

int error(PGresult*);

void eventdisplay();
void displayguestlist(string);
void mastergl_display();
void guest_checkin();
int check_primssion();


//global vars
PGconn *conn;
int status;
int userPrmissionLevel;
string username;


  enum entryP {GM, Door, FloorMgt};
   entryP usrpr;



int main(int argc, char* argv[]) {

// main vars
    char userfunctionselect[1];
    string authriz;

// loop to keep you inside the program.
    welcome(authriz);




    do {

// Welcome uses a pass by pointer to get user input,



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

                if (check_primssion()  > 1)
                {cout << "\n DO NOT HAVE PRIMSSION!!! \n";
                break;}

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
    string Primssions;

    cout << "\nPlease Input Your Database Username: ";
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

     string pr_querry;
    PGresult *res;
    PGresult *resname;
     pr_querry = "update Emploi_record set logout =(current_timestamp) where e_name='"+username +"'" ;

          res  = PQexec (conn, pr_querry.c_str());

          PQclear(res);

     PQfinish(conn);
    }

/* this deffy needs improving!!!*/
int error(PGresult *res) {
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
		puts("We did not get any data!");
           exit(2);
    return(1);
    }
else return 0;
}


void welcome(string& authriz ) {


      string pr_querry;
    PGresult *res;

	printf( "**\n **Welcome to attendance Guest_Event_MGMT_System **\n** \n");


        cout << setw(34) << "Enter Your Permission Level 1='GM'//2='FloorMgt'//3='Door': ";
                cin >> userPrmissionLevel;


             if (userPrmissionLevel = 1)
             { usrpr = GM;
                authriz = "GM";}

            if (userPrmissionLevel = 2)
            {  usrpr = FloorMgt;
         authriz ="FloorMgt";}

     if (userPrmissionLevel = 3)
            {   usrpr = Door;
        authriz ="Door";}


        cout << endl << " Enter Your name: ";
                cin >> username;

        conection();


 pr_querry = "insert into Emploi_record (e_name, authorizationz)values ('" + username+ "', " + "'"+ authriz + "');";

          res  = PQexec (conn, pr_querry.c_str());
       //   status = error(res);
          PQclear(res);
          cout <<  "\n your connection has been established, login noted Welcome "<< username << "!:)\n";

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


void guest_checkin()

{

    PGresult *res;

    string queryprep;

    string ticketnumber;
    string guestname;
    string attendstatus;

    char markattend;


    cout << "Please enter the guest's ticket number and press return: ";

    cin >> ticketnumber;



       queryprep= "select g_name from guest_list join guests on frkey_id_guest = guests.id_guest "
               "where ticket_number = "+ticketnumber;

    res  = PQexec (conn, queryprep.c_str());
    status = error(res);
      guestname  =  PQgetvalue(res, 0,0)   ;
              PQclear(res);


    queryprep =  "select attend from guest_list where ticket_number = " + ticketnumber ;

       res  = PQexec (conn, queryprep.c_str());
    status = error(res);
    attendstatus = PQgetvalue(res,0,0);
      PQclear(res);




   if (attendstatus == "t")
     {

       cout << endl<<  "The Ticket has already been signed in.."
            <<  " please insure ticket holder is correct person: " << guestname << endl;

   }

    if (attendstatus == "f"){

        cout << endl << "The guest must be signed in please confirm Idenity: "
             << guestname << "\n If correct sign person in? y/n?" ;

        cin >> markattend;

  if (markattend== 'y')

  {   queryprep= "update guest_list set attend = 'true' where ticket_number = " +ticketnumber;
        res  =   PQexec (conn, queryprep.c_str());

    PQclear(res);


  queryprep =  "select attend from guest_list where ticket_number = " + ticketnumber ;
  res  =   PQexec (conn, queryprep.c_str());
  attendstatus = PQgetvalue(res,0,0);
  status = error(res);

  if (attendstatus == "t")
     { cout << "\n Guest: " <<guestname << " Has been signed in!" << endl ;

  if (attendstatus == "f")
  { cout << "\n There has Been an error!!! \n";}
  }
  }
 ;
}
}
      void userinputselect(char &userfunctionselect)

   {
       cout << endl << "To enter Master-Guest-List utility type \"1\"|-|-| "
            << "To enter Guest check-in type \"2\"|-| or type q to quit and press return: " ;

     cin >> userfunctionselect;
   }


   int check_primssion()
   {

    switch (usrpr){

           case GM : return 0;
            break;

       case FloorMgt :
       return 1;
       break;

        case Door :
        return 2;
        break;

        default : return -3;
        }


   }
