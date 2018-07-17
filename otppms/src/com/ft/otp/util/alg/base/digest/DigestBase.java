package com.ft.otp.util.alg.base.digest;

/**
 *  
 * 摘要算法的基础类
 * 注意：本类是一抽象类,具体的摘要值计算其实是在子类中实现的
 * *
 * @Date in Mar 5, 2013,3:50:53 PM
 *
 * @version v1.0
 *
 * @author KK David
 */
public abstract class DigestBase implements IDigest {
    protected String algName;
    protected int digestLen;
    protected int blockLen;

    protected byte[] xBuf;
    protected int xBufOff;

    protected long byteCount;

    protected DigestBase() {
        xBuf = new byte[4];
        xBufOff = 0;
    }

    public String getAlgorithmName() {
        return algName;
    }

    public int getBlockLength() {
        return blockLen;
    }

    public int getDigestLength() {
        return digestLen;
    }

    public void update(byte in) {
        xBuf[xBufOff++] = in;

        if (xBufOff == xBuf.length) {
            processWord(xBuf, 0);
            xBufOff = 0;
        }

        byteCount++;
    }

    public void update(byte[] in) {
        update(in, 0, in.length);
    }

    public void update(byte[] in, int inOff, int len) {
        // 如果之前还不满，先处理完
        while ((xBufOff != 0) && (len > 0)) {
            update(in[inOff]);

            inOff++;
            len--;
        }

        // 处理整个的
        while (len > xBuf.length) {
            processWord(in, inOff);

            inOff += xBuf.length;
            len -= xBuf.length;
            byteCount += xBuf.length;
        }

        // 处理不足整个的
        while (len > 0) {
            update(in[inOff]);

            inOff++;
            len--;
        }
    }

    public void digest(byte[] out) {
        digest(out, 0);
    }

    public byte[] digest() {
        byte[] out = new byte[digestLen];
        digest(out);

        return out;
    }

    protected void finish() {
        long bitLength = (byteCount << 3);

        update((byte) 128);

        while (xBufOff != 0) {
            update((byte) 0);
        }

        processLength(bitLength);

        processBlock();
    }

    public void reset() {
        byteCount = 0;

        xBufOff = 0;
        for (int i = 0; i < xBuf.length; i++) {
            xBuf[i] = 0;
        }
    }

    //
    // 以下三个抽象方法每个摘要算法的实现会不一样,需要单独实现
    //

    // 处理一个字
    protected abstract void processWord(byte[] in, int inOff);

    // 处理长度
    protected abstract void processLength(long bitLength);

    // 处理一个块
    protected abstract void processBlock();
}
