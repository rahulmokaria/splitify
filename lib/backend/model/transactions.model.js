const {Schema,model}=require('mongoose')
const transactionschema=new Schema({
    transactiontype:{
       type:String,
       required:true
    },
    amount:{
        type:Number,
        required:true
    },
    category:{
        type:String,
        required:true
    },
    description:{
        type:String,
        required:true
    },
    date:{
        type:String,
        required:true
    },
    userid:{
        type:String,
        required:true
    }

});

const transactionmodel=model("transactions",transactionschema);
module.exports={transactionmodel};