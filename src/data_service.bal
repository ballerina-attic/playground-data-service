import ballerina/config;
import ballerina/http;
import ballerina/h2;
import ballerina/sql;

listener http:Listener httpListener = new(9090);

// Get database credentials via configuration API.
final string USER_NAME =  config:getAsString("username");
final string PASSWORD = config:getAsString("password");
final string DB_HOST = config:getAsString("db_host");
final string DB_NAME = "CUSTOMER_DB";

@http:ServiceConfig {
    basePath:"/"
}
service CustomerDataMgt on httpListener {

  @http:ResourceConfig {
    methods:["GET"],
    path:"/customer"
  }
  resource function customers(http:Caller caller, http:Request req) {

    // SQL client enables interaction with databases
    h2:Client customerDB = new({
        path: DB_HOST,
        name: DB_NAME,
        username: USER_NAME,
        password: PASSWORD,
        poolOptions: { maximumPoolSize: 1 }
      });

    http:Response res = new;

    // Invokes 'select' remote function against the client.
    // The 'table' primitive type represents a set of records.
    var selectRet = customerDB->
        select("SELECT * FROM CUSTOMER", ());
    if (selectRet is table<record {}>) {
      // Tables can be cast to JSON and XML
      var response = json.convert(selectRet);
      if (response is json) {
        res.setPayload(untaint response);
      } else {
        res.statusCode = 500;
        res.setPayload({ "Error": "Internal error occurred"});
      }
    } else {
      res.statusCode = 500;
      res.setPayload({ "Error": "Internal error occurred"});
    }
    _ = caller->respond(res);
  }
}
