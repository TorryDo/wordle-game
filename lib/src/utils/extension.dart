extension Repeat on Function{
  void repeat(int count){
    for(int _=0; _<count; _++) {
      this();
    }
  }
}