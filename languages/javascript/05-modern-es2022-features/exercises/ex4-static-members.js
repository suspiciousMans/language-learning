// ex4-static-members.js
// Static methods and properties in ES2022.

class DatabaseConnection {
  static connections = [];
  static maxConnections = 10;

  constructor(id) {
    this.id = id;
    this.connected = false;
  }

  connect() {
    if (DatabaseConnection.connections.length >= DatabaseConnection.maxConnections) {
      throw new Error('Too many connections');
    }
    this.connected = true;
    DatabaseConnection.connections.push(this);
    console.log(`Connected ${this.id}`);
  }

  disconnect() {
    this.connected = false;
    DatabaseConnection.connections = DatabaseConnection.connections.filter((c) => c.id !== this.id);
    console.log(`Disconnected ${this.id}`);
  }

  static getConnectionCount() {
    return DatabaseConnection.connections.length;
  }

  static listConnections() {
    return DatabaseConnection.connections.map((c) => c.id);
  }
}

const db1 = new DatabaseConnection('db1');
const db2 = new DatabaseConnection('db2');

db1.connect();
db2.connect();

console.log('Active connections:', DatabaseConnection.getConnectionCount());
console.log('Connection IDs:', DatabaseConnection.listConnections());

db1.disconnect();
console.log('After disconnect:', DatabaseConnection.getConnectionCount());
