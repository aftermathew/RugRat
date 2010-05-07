package com.bitsyrup.rugrat.xmlserializable;

public interface I_XMLSerializable {

	abstract String toXML();
	abstract void fromXML(String xml);
}
