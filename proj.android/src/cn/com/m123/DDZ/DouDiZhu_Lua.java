/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package cn.com.m123.DDZ;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxGLSurfaceView;

import cn.com.m123.DDZ.push.PushDataManager;

import android.content.Context;
import android.media.AudioManager;
import android.os.Bundle;

public class DouDiZhu_Lua extends Cocos2dxActivity{
	
	public static int initial_volume = 0;
	public static DouDiZhu_Lua INSTANCE;
	
	protected void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		DDZJniHelper.messageCpp("game_jni");
		INSTANCE = this;
		PushDataManager.pushNotification(this, null);
	}
	
	public Cocos2dxGLSurfaceView onCreateView() {
    	Cocos2dxGLSurfaceView glSurfaceView = new Cocos2dxGLSurfaceView(this);
    	glSurfaceView.setEGLConfigChooser(5, 6, 5, 0, 16, 8);
    	return glSurfaceView;
    }
	
    static {
         System.loadLibrary("game");
    }
    
    @Override
    protected void onResume() {
    	/*
    	System.out.println("DouDiZhu_Lua onResume");
    	AudioManager am = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
    	initial_volume = am.getStreamVolume(AudioManager.STREAM_MUSIC); 
    	int max = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
    	am.setStreamVolume(AudioManager.STREAM_MUSIC, max, 0);
    	*/
    	super.onResume();
    }
    
    @Override
    protected void onPause() {
    	/*
    	System.out.println("DouDiZhu_Lua onPause");
    	AudioManager am = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
    	am.setStreamVolume(AudioManager.STREAM_MUSIC, initial_volume, 0);
    	*/
    	super.onPause();
    }
    
    @Override
    protected void onDestroy() {
    	INSTANCE = null;
    	super.onDestroy();
    }

}
