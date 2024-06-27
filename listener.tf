resource "aws_lb_listener" "external-alb" {
  load_balancer_arn = aws_lb.external-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-elb.arn
  }
}
listener_arn = aws_lb_listener.external-alb.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-elb.arn
  }
condition {
    path_pattern {
      values = ["/my_listener_rule/*"]
    }
  }
}
