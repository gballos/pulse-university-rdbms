# Pulse University RDBMS

## How to use the app

**0.  If you are on Windows** 

  ensure that running scripts in Powershell is allowed with executing the command

  `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` from an elevated Powershell

**1.  Clone this repo with `git clone <https://github.com/gballos/pulse-university-rdbms>` and navigate to `pulse-university-rdbms/code/docker`**

**2.  Build the docker with `./build.ps1` on Windows and  `./build.sh` on Linux**

  This should initialize MySQL container and the database using the sql scripts in `pulse-universisty-rdbms/sql/scripts`. Make sure you have Dokcer Desktop active. You can also check the logs of the installation process to check if any errors occured with `docker logs pulse_uni_db_container`.

**3.  Connect to the DB in an IDE(i.e. MySQL Workbench)**

  1.  Open IDE(i.e. MySQL Workbench)
    
  2.  Create a new connection
        - Hostname : `localhost`
        - Port : `3306`
        - Username : `myuser` or `root` for elevated access
        - Password : `mypassword` or `rootpassword` for root user
  3.  Click 'Test Connection' and Save

**4.  Interact with the DB**

  Now you can use your IDE of choice to execute queries, insert new data etc...
  
**5.  Terminate Connection**
  
  Once done you can use `docker compose down -v` to shut down the database container.

## Features

- **Staff Coverage**: Check staff assigned vs staff required for each event using the `staff_coverage_view`.
- **Resale Queue**: When somebody tries to buy a ticket but they are sold out he is logged as a *buyer* that wants to buy ticket for that specific event. If somebody changes his mind about his ticket and his ticket is unscanned he can list his ticket for resale in the resale queue. The queue works in a *FIFO* way. We are constantly matching buyers and sellers based on their needs. If they match we remove them from the queue.
- **Conscutive Festival Appearences**: A performer(band or artist) can not take part in the festival for more than 3 years in a row.
- **Breaks between performances**: Between consecutive performances(in an event) there must be a 5 to 30 minute break. 
