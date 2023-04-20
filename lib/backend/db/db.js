const mongoose =require('mongoose');
const pool=mongoose.connect(process.env.MONGO_URL)
.then(function(db){
  console.log("db is connected 🎉🎉🎉");
})
.catch(function(err){
  console.log('error at mongo connection',err.message);
})

mongoose.connection.on('connected',()=>{
  console.log('connectes to data base')
})
mongoose.connection.on('error',(err)=>{
  console.log(err.message);
}) 
mongoose.connection.on('disconnected',()=>{
  console.log('db disconnected succesfully');
})

process.on('SIGINT',async ()=>{
  await mongoose.connection.close();
  process.exit(0);
})
module.exports=pool;

