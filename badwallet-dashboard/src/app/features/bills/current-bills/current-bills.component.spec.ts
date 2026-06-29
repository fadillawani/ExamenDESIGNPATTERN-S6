import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CurrentBillsComponent } from './current-bills.component';

describe('CurrentBillsComponent', () => {
  let component: CurrentBillsComponent;
  let fixture: ComponentFixture<CurrentBillsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CurrentBillsComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CurrentBillsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
