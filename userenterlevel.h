/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   userenterlevel.h
 * Author: zepalz
 *
 * Created on November 23, 2017, 10:24 PM
 */
#include <iostream>
#include <vector>
#include <prmissionstatus.h>
#include <string>

using namespace std
        ; 
#ifndef USERENTERLEVEL_H
#define USERENTERLEVEL_H

class userenterlevel {
enum entryP {GM, Door, FloorMgt};
entryP userocurz;

private:
    
    string upinput;
    bool conectionauthetic;
    static vector <userocurz>;
     static struct datapassage{
         string  runtimename;
         enum flag {contun, drop, config};
         
     
     };
protected: 
    entryP usrpr;
    

public:
    userenterlevel();
    userenterlevel(const userenterlevel& orig);
    virtual ~userenterlevel();
    
    void userPrmissionInput(string usrinput);


    
};

#endif /* USERENTERLEVEL_H */

