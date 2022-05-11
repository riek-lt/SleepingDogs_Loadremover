state("SDHDShip")
{
	int loading : 0x0207B000, 0x260;
}

state("HKShip")
{
	int loading: 0x000620E0, 0x418;
}
isLoading
{
	if (current.loading ==1)
		return true;
	else
		return false;
	
}