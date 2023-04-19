const mongoose=require('mongoose');
const {Schema,model} =mongoose;
const bcrypt=require('bcrypt')
const userschema=new Schema({
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

userschema.pre('save',async function(){
        let salt=await bcrypt.genSalt(10);
        let hash=await bcrypt.hash(this.password,salt)
        this.password=hash
})

const usermodel=model("userdetails",userschema)
module.exports={usermodel}