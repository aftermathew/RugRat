package com.bitsyrup.rugrat.common.assets;

import java.util.Comparator;

public class AssetSizeComparator implements Comparator<Asset>{

	@Override
	public int compare(Asset o1, Asset o2) {
		return o1.getSize() < o2.getSize() ? -1 : o1.getSize() == o2.getSize() ? 0 : 1;
	}
}
