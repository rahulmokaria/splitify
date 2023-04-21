const mongoose=require('mongoose')
const {Schema,model} =mongoose;
const detailsschema=new Schema({
    amount:{
        type:Number,
        default:0
    },
    userid:{
        type:String,
        required:true
    },
    income:{
        type:Number,
        default:0
    },
    expense:{
        type:Number,
        default:0
    }
})
const detailsmodel=model("userdata",detailsschema);
module.exports={detailsmodel};

