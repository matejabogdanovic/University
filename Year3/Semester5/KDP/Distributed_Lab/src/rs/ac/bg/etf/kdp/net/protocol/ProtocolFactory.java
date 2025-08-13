package rs.ac.bg.etf.kdp.net.protocol;

import rs.ac.bg.etf.kdp.net.Protocol;

public class ProtocolFactory {

	public Protocol createProtocol(String protocolName) {
		Protocol protocol = null;
		String protocolPackageRoot = Protocol.class.getPackage().getName();
		try {
			String clsName = protocolPackageRoot + ".protocol." + protocolName;
			Class<?> cls = null;
			try {
				cls = Class.forName(clsName);
			} catch (ClassNotFoundException e) {
				ClassLoader cl = ClassLoader.getSystemClassLoader();
				if (cl != null) {
					cls = cl.loadClass(clsName);
				}
			}
			if (cls != null) {
				protocol = (Protocol) cls.getDeclaredConstructor().newInstance();
			}
		} catch (Exception e) {
		}
		return protocol;
	}
}
