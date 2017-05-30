package Visual.Tetris;
import remixlab.proscene.*;
import processing.core.*;

import static processing.core.PConstants.*;

/**
 * Created by gggonzalezg on 5/29/17.
 */

public class Tetramino extends InteractiveFrame{
    float size;
    float padding = 0f;
    Board board;

    public Tetramino(Scene scene, float size, Board board) {
        super(scene);
        this.size = size;
        this.board = board;
        removeBindings();
        disableVisualHint();
        setHighlightingMode(InteractiveFrame.HighlightingMode.NONE);
        setShape("display");
        setClickBinding(LEFT, 1, "play");
    }

    public float getSize() {
        return size;
    }

    public void play(){
        board.movePiece();
    }

    public void display(PGraphics pg){
        pg.pushStyle();
        pg.fill((float)(Math.random()*255) , (float)(Math.random()*255), (float)(Math.random()*255));
        pg.stroke(255);
        pg.strokeWeight(3);

        float thickness = 6;
        pg.beginShape();
        pg.vertex(-getSize() / 2, -getSize() / 2, -thickness);
        pg.vertex(getSize() / 2, -getSize() / 2, -thickness);
        pg.vertex(getSize() / 2, getSize() / 2, -thickness);
        pg.vertex(-getSize() / 2, getSize() / 2, -thickness);
        pg.endShape(CLOSE);
        pg.beginShape();
        pg.vertex(-getSize() / 2, -getSize() / 2, 0);
        pg.vertex(-getSize() / 2, getSize() / 2, 0);
        pg.vertex(-getSize() / 2, getSize() / 2, -thickness);
        pg.vertex(-getSize() / 2, -getSize() / 2, -thickness);
        pg.endShape(CLOSE);
        pg.beginShape();
        pg.vertex(getSize() / 2, -getSize() / 2, 0);
        pg.vertex(getSize() / 2, getSize() / 2, 0);
        pg.vertex(getSize() / 2, getSize() / 2, -thickness);
        pg.vertex(getSize() / 2, -getSize() / 2, -thickness);
        pg.endShape(CLOSE);
        pg.beginShape();
        pg.vertex(-getSize() / 2, -getSize() / 2, 0);
        pg.vertex(getSize() / 2, -getSize() / 2, 0);
        pg.vertex(getSize() / 2, -getSize() / 2, -thickness);
        pg.vertex(-getSize() / 2, -getSize() / 2, -thickness);
        pg.endShape(CLOSE);
        pg.beginShape();
        pg.vertex(-getSize() / 2, getSize() / 2, 0);
        pg.vertex(getSize() / 2, getSize() / 2, 0);
        pg.vertex(getSize() / 2, getSize() / 2, -thickness);
        pg.vertex(-getSize() / 2, getSize() / 2, -thickness);
        pg.endShape(CLOSE);
        pg.beginShape();
        pg.vertex(-getSize() / 2, -getSize() / 2, 0);
        pg.vertex(-getSize() / 2, getSize() / 2, 0);
        pg.vertex(getSize() / 2, getSize() / 2, 0);
        pg.vertex(getSize() / 2, -getSize() / 2, 0);
        pg.endShape(CLOSE);
        pg.popStyle();
    }

}
