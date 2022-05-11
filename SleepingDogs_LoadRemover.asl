state("SDHDShip")
{
	int loading : 0x207B000, 0x260;
}

state("HKShip")
{
	int loading: 0x620E0, 0x418;
}

isLoading
{
	return current.loading == 1;
}
