import sql from "mssql";

export const dbConfig = {
    user: "sa",
    password: "1234",
    database: "SICODOC",
    server: "localhost",
    options: {
        encrypt: false,
        trustServerCertificate: true
    }
};

export const pool = new sql.ConnectionPool(dbConfig);
export const poolConnect = pool.connect();

export const dbItculiacan = {
    user: "sa",
    password: "1234",
    database: "itculiacan",
    server: "localhost",
    options: {
        encrypt: false,
        trustServerCertificate: true
    }
};

export const poolItc = new sql.ConnectionPool(dbItculiacan);
export const poolItcConnect = poolItc.connect();
