package Visual.Tetris;

import processing.core.*;
import remixlab.dandelion.geom.*;
import remixlab.proscene.*;

import static processing.core.PConstants.CLOSE;
import static processing.core.PConstants.LEFT;

/**
 * Created by gggonzalezg on 5/29/17.
 */

public class Tetris extends PApplet{
    public Scene scene;
    public Board board;

    public void settings(){
        size(600,600, P3D);
    }

    public void setup(){
        scene = new Scene(this);
        scene.setAxesVisualHint(false);
        scene.setGridVisualHint(false);
        board = new Board(3,20,10, this);
        scene.camera().setPosition(new Vec(-20, 100, 230));
        scene.camera().lookAt(new Vec(0,0,0));
    }

    public void draw() {
        background(0);
        lights();
        directionalLight(50, 50, 50, ((Quat)scene.camera().orientation()).x() - scene.camera().position().x(), ((Quat)scene.camera().orientation()).y() - scene.camera().position().y(), ((Quat)scene.camera().orientation()).z() - scene.camera().position().z());
        spotLight(150, 150, 150, scene.camera().position().x(), scene.camera().position().y(), scene.camera().position().z(), 0, 0, -1, 1, 20);
        spotLight(100, 100, 100, scene.camera().position().x(), scene.camera().position().y(), scene.camera().position().z(), 0, 0, 1, 1, 20);
        board.update();
        scene.drawFrames();
    }

    public static void main(String[] args) {
        main(Tetris.class.getName());
    }

}