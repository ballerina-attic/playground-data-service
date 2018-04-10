import ballerina/http;
import ballerina/sql;
import ballerina/config;


// Get database credentials via configuration API.
@final string user_name = "root";
@final string password = "root";
@final string DB_NAME="CUSTOMER_DB";

@http:ServiceConfig {
    basePath:"/"
}
service<http:Service> data_service bind {} {

    @http:ResourceConfig {
        methods:["GET"],
        path:"/customer"
    }
    customers (endpoint caller, http:Request req) {

        // Endpoints can connect to dbs with SQL connector
        endpoint sql:Client customerDB {
            database:sql:DB_H2_FILE,
            host:"/sample-db/",
            port:10,
            name:DB_NAME,
            username:user_name,
            password:password,
            options:{ maximumPoolSize:5 }
        };

        // Invoke 'select' command against remote database
        // table primitive type represents a set of records
        table dt = check customerDB -> select(
                                  "SELECT * FROM CUSTOMER",
                                  null,
                                  null);

        // tables can be cast to JSON and XML
        json response = check <json>dt;

        http:Response res = new;
        res.setJsonPayload(response);
        _ = caller -> respond(res);
    }
}

