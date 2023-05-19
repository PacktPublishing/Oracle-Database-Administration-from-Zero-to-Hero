function $x(pNd){
  var lThis;
  switch(typeof (pNd)){
    case 'string':lThis = document.getElementById(pNd);break;
    case 'object':lThis = pNd;break;
    default:return false;break;
  }
  return (lThis.nodeType == 1)?lThis:false;
}

var gRegex=false;
var gHeight=0;
function $d_Find(pThis,pString,pTags,pClass){
       if(!pTags){pTags = 'DIV';}
       pThis = $x(pThis);
       if(pThis){
           var d=pThis.getElementsByTagName(pTags);
           pThis.style.display="none";
           if(!gRegex){gRegex =new RegExp("test");}
           gRegex.compile(pString,"i");
           for(var i=0,len=d.length ;i<len;i++){
               if(gRegex.test(d[i].innerHTML)){
                   d[i].style.display="table-row";
                   d[i].style.visiblilty="visible";
                   d[i].style.height=gHeight;
               } else{
                   if ( gHeight==0)  gHeight=d[i].style.height;
                   d[i].style.height='0';
                   d[i].style.display="none";
                   d[i].style.visiblilty="hidden";
               }
           }
       pThis.style.display="block";
   }
   return;
}
