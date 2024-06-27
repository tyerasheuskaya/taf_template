*** Variables ***
# Connections to Oracle 12
&{ORACLE12}    HOST=ORACLE12_HOST    SID=ORACLE12_SID    PORT=ORACLE12_PORT    USER=ORACLE12_USER  PASSWORD=ORACLE12_PASSWORD
# Connections to Oracle 19
&{ORACLE19}    HOST=localhost    SID=LOCALDB    PORT=8888    USER=system  PASSWORD=ORA19

# Connections to SQLIGHT
&{SQLIGHT}     DATABASE="./Chinook.db"
