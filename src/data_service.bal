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
  resource function customers(http:Caller caller, http:Request req)
                        returns error? {
    // Database client enables interaction with databases
    h2:Client customerDB = new({
        path: DB_HOST,
        name: DB_NAME,
        username: USER_NAME,
        password: PASSWORD,
        poolOptions: { maximumPoolSize: 1 }
      });

    // Invokes 'select' remote function against the client.
    // The 'table' primitive type represents a set of records.
    table<record {}> dt = check customerDB->
            select("SELECT * FROM CUSTOMER", ());

    // Tables can be converted to JSON and XML
    json response = check json.convert(dt);

    http:Response res = new;
    res.setPayload(untaint response);
    _ = check caller->respond(res);

    return;
  }
}
