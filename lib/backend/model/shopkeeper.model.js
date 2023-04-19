const mongoose=require('mongoose');
const {Schema,model} =mongoose;
const bcrypt=require('bcrypt')
const shopkeeperschema=new Schema({
  email:{
    type:String,
    required:[true,"Email is required"]
  },
  name:{
    type:String,
    required:[true,"Name is required"]
  },
  password:{
    type:String,
    required:[true,"Password is required"]
  }
})

shopkeeperschema.pre('save',async function(){
        let salt=await bcrypt.genSalt(10);
        let hash=await bcrypt.hash(this.password,salt)
        this.password=hash
})

const shopkeepermodel=model("shopkeeperdetails",shopkeeperschema)
module.exports={shopkeepermodel}