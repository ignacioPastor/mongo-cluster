mongod --replSet 'rs1'
echo "Waiting for startup.."
until [[mongo --host comp-mongo-node2:27017 --eval 'quit(db.runCommand({ ping: 1 }).ok ? 0 : 2)' &>/dev/null || mongo --host comp-mongo-node3:27017 --eval 'quit(db.runCommand({ ping: 1 }).ok ? 0 : 2)' &>/dev/null]];
do
  printf '.'
  sleep 1
done

echo "---------------------------------------------------------"
echo "Starting replica set..."
mongo <<EOF
   var cfg = {
        "_id": "rs1",
        "protocolVersion": 1,
        "members": [
          {
              "_id" : 0,
              "host" : "comp-mongo-node1:27017"
          },
          {
              "_id" : 1,
              "host" : "comp-mongo-node2:27017"
          },
          {
              "_id" : 2,
              "host" : "comp-mongo-node3:27017"
          }
        ]
    };
    rs.initiate(cfg);
    rs.reconfig(cfg, { force: true });
EOF
