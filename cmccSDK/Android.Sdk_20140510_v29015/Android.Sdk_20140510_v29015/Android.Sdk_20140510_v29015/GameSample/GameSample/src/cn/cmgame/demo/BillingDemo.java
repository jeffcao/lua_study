package cn.cmgame.demo;


import android.app.ListActivity;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.*;
import android.widget.AdapterView.OnItemClickListener;
import cn.cmgame.billing.api.BillingResult;
import cn.cmgame.billing.api.GameInterface;
import cn.cmgame.billing.api.GameInterface.*;

public class BillingDemo extends ListActivity {

  static final String[] BUTTONS = new String[]{
    "00.购买计费点：001",
    "01.购买计费点：002",
    "02.购买计费点：003",
    "03.购买计费点：004",
    "04.购买计费点：005",
    "05.购买计费点：006",
    "06.购买计费点：007",
    "07.购买计费点：008",
    "08.购买计费点：009",
    "09.购买计费点：010",
    "10.购买计费点：011",
    "11.购买计费点：012",
    "12.购买计费点：013",
    "13.购买计费点：014",
    "14.购买计费点：015",
    "15.退出游戏"
  };


  /**
   * Called when the activity is first created.
   */
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    //不显示程序的标题栏
    requestWindowFeature(Window.FEATURE_NO_TITLE);

    //不显示系统的标题栏
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

    // SDK初始化接口，必须首先调用，且在主线程调用
    GameInterface.initializeApp(this);

    // 支付或购买道具回调结果
    final IPayCallback payCallback = new IPayCallback() {
      @Override
      public void onResult(int resultCode, String billingIndex, Object obj) {
        String result = "";
        switch (resultCode) {
          case BillingResult.SUCCESS:
            result = "购买道具：[" + billingIndex + "] 成功！";
            break;
          case BillingResult.FAILED:
            result = "购买道具：[" + billingIndex + "] 失败！";
            break;
          default:
            result = "购买道具：[" + billingIndex + "] 取消！";
            break;
        }
        Toast.makeText(BillingDemo.this, result, Toast.LENGTH_SHORT).show();
      }
    };

    setListAdapter(new ArrayAdapter<String>(this, R.layout.game_item, BUTTONS));
    ListView lv = getListView();
    lv.setOnItemClickListener(new OnItemClickListener() {
      public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        if (15 == position) {
          GameInterface.exitApp();
        } else {
          String billingIndex = getBillingIndex(position);
          boolean isRepeated = (position != 0);
          GameInterface.doBilling(BillingDemo.this, true, isRepeated, billingIndex, null, payCallback);
        }
      }
    });
  }

  private String getBillingIndex(int i) {
    if (i < 9) {
      return "00" + (++i);
    } else {
      return "0" + (++i);
    }
  }

  @Override
  public void onResume() {
    super.onResume();
  }

  /**
   * 移动游戏SDK：提供的退出接口
   */
  private void exitGame() {
    GameInterface.exitApp();
  }

  @Override
  public boolean onKeyDown(int keyCode, KeyEvent event) {
    if (keyCode == KeyEvent.KEYCODE_BACK) {
      exitGame();
      return true;
    }
    return super.onKeyDown(keyCode, event);
  }
}
