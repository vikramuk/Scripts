class BitTest {
	public static void main(String[] args) {
		int mask  = 0b00000011;
		int mask2 = 0b00110000;
		String Response = "FF FF 04 FF 05 FF 23 00";
		String Response1 = Response.replaceAll("\\s+","");
		System.out.print(Response1);
		for (int i =0; i< Response1.length();i=i+2) 
		{
			//System.out.println((char)(Response1.charAt(i))+(char)(Response1.charAt(i+1))); 
			//System.out.println((Response1.charAt(i)));
			//System.out.println((Response1.charAt(i+1))); 
			System.out.println((Response1.charAt(i))& mask2);
			System.out.println("New Value:"+((Response1.charAt(i))& mask2));
		}
		//System.out.println(n & mask);		
	}
}
