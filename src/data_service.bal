import ballerina/http;
import ballerina/sql;
import ballerina/h2;
import ballerina/config;

// Get database credentials via configuration API.
@final string USER_NAME =
       config:getAsString("username");
@final string PASSWORD =
       config:getAsString("password");
@final string DB_HOST =
       config:getAsString("db_host");
@final string DB_NAME="CUSTOMER_DB";

@http:ServiceConfig {
    basePath:"/"
}
service<http:Service> CustomerDataMgt bind {} {

  @http:ResourceConfig {
    methods:["GET"],
    path:"/customer"
  }
  customers (endpoint caller, http:Request req) {
    // Endpoints can connect to dbs with SQL connector
    endpoint h2:Client customerDB {
      path:DB_HOST,
      name:DB_NAME,
      username:USER_NAME,
      password:PASSWORD,
      poolOptions:{maximumPoolSize:1},
      dbOptions: ()
    };

    // Invoke 'select' command against remote database
    // table primitive type represents a set of records
    table dt = check customerDB -> select(
                              "SELECT * FROM CUSTOMER"
                              , null);

    // tables can be cast to JSON and XML
    json response = check <json>dt;

    http:Response res = new;
    res.setJsonPayload(response);
    _ = caller -> respond(res);
  }
}



