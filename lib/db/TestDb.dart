class DataBaseTest{
  DataBaseTest();
  DataBaseTest.hh();
  DataBaseTest.hh1();
  DataBaseTest.hh12();
  DataBaseTest.hh3();

  Future<String> getName() async{
    return  "Name";
  }
  Future<String> getNamea() async{
    String x=await getName();

    return  x;
  }

}